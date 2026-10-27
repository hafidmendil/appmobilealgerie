import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/services/auth_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/messaging/models/message_model.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';
import 'package:projetmascara/features/professional/models/session_request_model.dart';
import 'package:projetmascara/core/services/hive_assessment_repository.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/core/services/secure_storage_service.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/services/admin/hive_security_log_repository.dart';
import 'package:uuid/uuid.dart';

class HiveAuthRepository implements AuthRepository {
  final _uuid = const Uuid();
  final _authStateController = StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;
  final _secure = SecureStorageService();
  late final Future<void> _ready;

  HiveAuthRepository() {
    _ready = _init();
  }

  Future<void> _init() async {
    final box = Hive.box(HiveConfig.authBox);
    _currentUser = box.get('current_user');
    _authStateController.add(_currentUser);
  }

  String _passwordKey(String email) => 'pw_${email.toLowerCase()}';
  String _mfaKey(String userId) => 'mfa_$userId';

  String _hashPassword(String password, {String salt = ''}) {
    final bytes = utf8.encode(salt + password);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes);
  }

  String _newPasswordRecord(String password) {
    final salt = _uuid.v4();
    return 'v2:$salt:${_hashPassword(password, salt: salt)}';
  }

  bool _matchesPassword(String password, String stored) {
    if (!stored.startsWith('v2:')) {
      return stored == _hashPassword(password);
    }
    final parts = stored.split(':');
    return parts.length == 3 &&
        parts[2] == _hashPassword(password, salt: parts[1]);
  }

  Future<void> _audit({
    required String actorId,
    required String actorRole,
    required String action,
    String? targetId,
    required String status,
    Map<String, String>? metadata,
  }) async {
    try {
      await HiveSecurityLogRepository().logEvent(
        SecurityLog(
          id: _uuid.v4(),
          actorId: actorId,
          actorRole: actorRole,
          action: action,
          targetId: targetId,
          timestamp: DateTime.now().toUtc(),
          status: status,
          metadata: metadata,
        ),
      );
    } catch (_) {
      // Authentication must not disclose logging internals or log secrets.
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    await _ready;
    return _currentUser;
  }

  bool _canUseAccount(UserModel user) {
    switch (user.role) {
      case UserRole.user:
      case UserRole.admin:
        return user.status == 'active';
      case UserRole.psychologist:
        return user.status == 'active' || user.status == 'approved';
      case UserRole.guest:
        return false;
    }
  }

  @override
  Future<UserModel> login(
    String email,
    String password, {
    String? secondFactorCode,
  }) async {
    await _ready;
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final user = usersBox.values.firstWhere(
        (u) => u.email.toLowerCase() == normalizedEmail,
      );

      if (!_canUseAccount(user)) {
        await _audit(
          actorId: user.id,
          actorRole: user.role.name,
          action: 'login_denied_account_status',
          targetId: user.id,
          status: 'failure',
        );
        throw Exception('Ce compte n’est pas autorisé à se connecter');
      }

      // Verify password from secure storage
      final key = _passwordKey(normalizedEmail);
      final stored = await _secure.read(key);
      if (stored == null) {
        throw Exception('Aucun mot de passe défini pour cet utilisateur');
      }
      if (!_matchesPassword(password, stored)) {
        await _audit(
          actorId: user.id,
          actorRole: user.role.name,
          action: 'login_failed',
          targetId: user.id,
          status: 'failure',
        );
        logger.w('AuthRepository: credential verification failed');
        throw Exception('Utilisateur non trouvé ou identifiants incorrects');
      }

      // Upgrade legacy unsalted local hashes at the next successful login.
      if (!stored.startsWith('v2:')) {
        await _secure.write(key, _newPasswordRecord(password));
      }

      if (user.mfaRequired) {
        final storedMfa = await _secure.read(_mfaKey(user.id));
        if (storedMfa == null ||
            secondFactorCode == null ||
            storedMfa != _hashPassword(secondFactorCode, salt: user.id)) {
          await _audit(
            actorId: user.id,
            actorRole: user.role.name,
            action: 'mfa_verification_failed',
            targetId: user.id,
            status: 'failure',
          );
          throw Exception('Le code du second facteur est requis ou invalide');
        }
      }

      await _saveUserLocally(user);
      await _audit(
        actorId: user.id,
        actorRole: user.role.name,
        action: 'login_success',
        targetId: user.id,
        status: 'success',
        metadata: {'mfa': user.mfaRequired.toString()},
      );
      return user;
    } catch (e) {
      logger.e('Login failed for email $email: $e');
      throw Exception('Utilisateur non trouvé ou identifiants incorrects');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await _ready;
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.length < 6) {
      throw Exception('Les informations d’inscription sont invalides');
    }
    if (role != UserRole.user && role != UserRole.psychologist) {
      throw Exception('Ce type de compte ne peut pas être créé ici');
    }
    logger.i('Hive: Registering local user');
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    if (usersBox.isEmpty) {
      throw StateError(
        'Initialisez d’abord l’administrateur local de cet appareil.',
      );
    }
    final emailExists = usersBox.values.any(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );
    if (emailExists) {
      throw Exception('Cet email est déjà utilisé par un autre compte');
    }

    final newUser = UserModel(
      id: _uuid.v4(),
      email: normalizedEmail,
      role: role,
      status: role == UserRole.psychologist ? 'pending' : 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Store hashed password securely
    await _secure.write(
      _passwordKey(normalizedEmail),
      _newPasswordRecord(password),
    );

    await _saveUserLocally(newUser);
    await _audit(
      actorId: newUser.id,
      actorRole: newUser.role.name,
      action: 'account_registered',
      targetId: newUser.id,
      status: 'success',
    );
    return newUser;
  }

  @override
  Future<UserModel> initializeOfflineAdministrator({
    required String email,
    required String password,
  }) async {
    await _ready;
    final normalizedEmail = email.trim().toLowerCase();
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);

    if (usersBox.isNotEmpty) {
      throw StateError(
        'L’administrateur local ne peut être créé que lors de la première installation.',
      );
    }
    if (normalizedEmail.isEmpty || password.length < 12) {
      throw ArgumentError(
        'Utilisez une adresse e-mail valide et un mot de passe de 12 caractères minimum.',
      );
    }

    final administrator = UserModel(
      id: _uuid.v4(),
      email: normalizedEmail,
      role: UserRole.admin,
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _secure.write(
      _passwordKey(normalizedEmail),
      _newPasswordRecord(password),
    );
    await _saveUserLocally(administrator);
    await _audit(
      actorId: administrator.id,
      actorRole: UserRole.admin.name,
      action: 'offline_administrator_initialized',
      targetId: administrator.id,
      status: 'success',
    );
    return administrator;
  }

  Future<void> _saveUserLocally(UserModel user) async {
    try {
      _currentUser = user;
      final authBox = Hive.box(HiveConfig.authBox);
      // Create copies to avoid "same instance in two boxes" error
      await authBox.put('current_user', user.copyWith());

      final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
      await usersBox.put(user.id, user.copyWith());

      logger.i('Hive: User ${user.email} saved successfully to local boxes');
      _authStateController.add(user);
    } catch (e) {
      logger.e('Hive: Error saving user locally: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _ready;
    final user = _currentUser;
    _currentUser = null;
    final authBox = Hive.box(HiveConfig.authBox);
    await authBox.delete('current_user');
    _authStateController.add(null);
    if (user != null) {
      await _audit(
        actorId: user.id,
        actorRole: user.role.name,
        action: 'logout',
        targetId: user.id,
        status: 'success',
      );
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _ready;
    // A local reset cannot safely prove account ownership or deliver a secret.
    // Do not silently change credentials and leave the user locked out.
    await _audit(
      actorId: 'anonymous',
      actorRole: 'anonymous',
      action: 'password_reset_self_service_requested',
      status: 'failure',
      metadata: {'email_present': email.trim().isNotEmpty.toString()},
    );
    throw UnsupportedError(
      'La réinitialisation locale doit être validée par un administrateur autorisé.',
    );
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    await _ready;
    if (newPassword.length < 12) {
      throw ArgumentError(
        'Le nouveau mot de passe doit contenir 12 caractères minimum',
      );
    }
    final users = Hive.box<UserModel>(HiveConfig.usersBox);
    final user = users.get(userId);
    if (user == null || _currentUser?.id != userId) {
      throw StateError('Modification du mot de passe non autorisée');
    }
    final key = _passwordKey(user.email);
    final stored = await _secure.read(key);
    if (stored == null || !_matchesPassword(currentPassword, stored)) {
      await _audit(
        actorId: userId,
        actorRole: user.role.name,
        action: 'password_change_failed',
        targetId: userId,
        status: 'failure',
      );
      throw ArgumentError('Le mot de passe actuel est incorrect');
    }
    await _secure.write(key, _newPasswordRecord(newPassword));
    final updated = user.copyWith(
      mustChangePassword: false,
      updatedAt: DateTime.now(),
    );
    await users.put(userId, updated);
    _currentUser = updated;
    await Hive.box(HiveConfig.authBox).put('current_user', updated.copyWith());
    _authStateController.add(updated);
    await _audit(
      actorId: userId,
      actorRole: user.role.name,
      action: 'password_changed',
      targetId: userId,
      status: 'success',
    );
  }

  @override
  Future<void> adminResetPassword({
    required String adminId,
    required String userId,
    required String temporaryPassword,
  }) async {
    await _ready;
    if (temporaryPassword.length < 12) {
      throw ArgumentError(
        'Le mot de passe temporaire doit contenir 12 caractères minimum',
      );
    }
    final users = Hive.box<UserModel>(HiveConfig.usersBox);
    final admin = users.get(adminId);
    final user = users.get(userId);
    if (admin?.role != UserRole.admin || user == null || adminId == userId) {
      throw StateError('Opération de réinitialisation non autorisée');
    }
    await _secure.write(
      _passwordKey(user.email),
      _newPasswordRecord(temporaryPassword),
    );
    final updated = user.copyWith(
      mustChangePassword: true,
      updatedAt: DateTime.now(),
    );
    await users.put(user.id, updated);
    await _audit(
      actorId: adminId,
      actorRole: UserRole.admin.name,
      action: 'password_reset_by_admin',
      targetId: userId,
      status: 'success',
    );
  }

  @override
  Future<void> setMfaRequirement({
    required String adminId,
    required String userId,
    required bool required,
    String? enrollmentCode,
  }) async {
    await _ready;
    final users = Hive.box<UserModel>(HiveConfig.usersBox);
    final admin = users.get(adminId);
    final user = users.get(userId);
    if (admin?.role != UserRole.admin || user == null || adminId == userId) {
      throw StateError('Configuration MFA non autorisée');
    }
    if (required &&
        (enrollmentCode == null ||
            !RegExp(r'^\d{6,10}$').hasMatch(enrollmentCode))) {
      throw ArgumentError(
        'Le code MFA local doit contenir entre 6 et 10 chiffres',
      );
    }
    if (required) {
      await _secure.write(
        _mfaKey(userId),
        _hashPassword(enrollmentCode!, salt: userId),
      );
    } else {
      await _secure.delete(_mfaKey(userId));
    }
    await users.put(
      userId,
      user.copyWith(mfaRequired: required, updatedAt: DateTime.now()),
    );
    await _audit(
      actorId: adminId,
      actorRole: UserRole.admin.name,
      action: required ? 'mfa_required_enabled' : 'mfa_required_disabled',
      targetId: userId,
      status: 'success',
    );
  }

  @override
  Future<void> verifyEmail() async {
    await _ready;
    // Mark current user as verified/active
    if (_currentUser == null) return;
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    final updated = _currentUser!.copyWith(
      status: 'active',
      updatedAt: DateTime.now(),
    );
    await box.put(updated.id, updated);
    _currentUser = updated;
    final authBox = Hive.box(HiveConfig.authBox);
    await authBox.put('current_user', updated);
    _authStateController.add(updated);
  }

  @override
  Future<void> migrateGuestData(String userId) async {
    await _ready;
    await HiveAssessmentRepository().migrateGuestAssessments(userId);
    logger.i('Guest assessment data migrated to the registered account');
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    return box.values.toList();
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    await _ready;
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    final user = box.get(userId);
    if (user != null) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await box.put(userId, updated);
      if (_currentUser?.id == userId) {
        _currentUser = updated;
        await Hive.box(HiveConfig.authBox).put('current_user', updated);
        _authStateController.add(updated);
      }
      await _audit(
        actorId: _currentUser?.id ?? 'system',
        actorRole: _currentUser?.role.name ?? 'system',
        action: 'account_status_updated',
        targetId: userId,
        status: 'success',
        metadata: {'new_status': status},
      );
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _ready;
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    await box.put(user.id, user);

    if (_currentUser?.id == user.id) {
      _currentUser = user;
      final authBox = Hive.box(HiveConfig.authBox);
      await authBox.put('current_user', user);
      _authStateController.add(user);
    }
  }

  @override
  Future<void> deleteCurrentUserData() async {
    await _ready;
    final user = _currentUser;
    if (user == null) return;

    final assessments = Hive.box<AssessmentRecord>(
      HiveConfig.assessmentResultsBox,
    );
    for (final key in assessments.keys.toList()) {
      if (assessments.get(key)?.userId == user.id) {
        await assessments.delete(key);
      }
    }

    final requests = Hive.box<AccessRequest>(HiveConfig.accessRequestsBox);
    for (final key in requests.keys.toList()) {
      final request = requests.get(key);
      if (request?.userId == user.id || request?.professionalId == user.id) {
        await requests.delete(key);
      }
    }

    final messages = Hive.box<MessageModel>(HiveConfig.messagesBox);
    for (final key in messages.keys.toList()) {
      final message = messages.get(key);
      if (message?.fromUserId == user.id || message?.toUserId == user.id) {
        await messages.delete(key);
      }
    }

    if (user.role == UserRole.psychologist) {
      await Hive.box<ProfessionalProfile>(
        HiveConfig.profilesBox,
      ).delete(user.id);
      final sessions = Hive.box<SessionRequestModel>(
        HiveConfig.sessionRequestsBox,
      );
      for (final key in sessions.keys.toList()) {
        final request = sessions.get(key);
        if (request?.professionalId == user.id.hashCode) {
          await sessions.delete(key);
        }
      }
    }

    await Hive.box(HiveConfig.userStatsBox).delete('stats_${user.id}');
    await Hive.box(HiveConfig.usersBox).delete(user.id);
    await _secure.delete(_passwordKey(user.email));
    await logout();
  }
}
