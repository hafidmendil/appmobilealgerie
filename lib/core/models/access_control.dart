import '../auth/user_role.dart';

class AccessControl {
  static bool canAccessUserProfile(UserRole actorRole, UserRole targetRole) {
    return actorRole == UserRole.admin ||
        actorRole == UserRole.psychologist && targetRole == UserRole.user;
  }

  static bool canViewPatientHistory(UserRole actorRole) {
    return actorRole == UserRole.psychologist || actorRole == UserRole.admin;
  }

  static bool canValidatePsychologist(UserRole actorRole) {
    return actorRole == UserRole.admin;
  }

  static bool canManageGlobalSettings(UserRole actorRole) {
    return actorRole == UserRole.admin;
  }
}
