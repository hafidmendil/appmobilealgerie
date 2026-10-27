import 'user_role.dart';

class RolePermissions {
  static const Set<String> patientPermissions = {
    'create_profile',
    'complete_assessment',
    'view_own_results',
    'update_own_preferences',
    'view_recommendations',
    'do_checkin',
    'search_psychologists',
    'request_relation',
    'view_own_notifications',
    'view_own_appointments',
    'manage_own_consent',
  };

  static const Set<String> psychologistPermissions = {
    'view_approved_patients',
    'accept_or_reject_request',
    'send_message_to_authorized_patients',
    'manage_own_availability',
    'view_patient_relevant_history',
    'manage_appointments',
    'manage_profile_verification',
    'view_own_notifications',
  };

  static const Set<String> adminPermissions = {
    'validate_psychologists',
    'suspend_accounts',
    'manage_permissions',
    'review_reports',
    'supervise_relations',
    'manage_content',
    'consult_statistics',
    'consult_security_logs',
    'manage_global_settings',
  };

  static Set<String> forRole(UserRole role) {
    switch (role) {
      case UserRole.user:
        return patientPermissions;
      case UserRole.psychologist:
        return psychologistPermissions;
      case UserRole.admin:
        return adminPermissions;
      case UserRole.guest:
        return const {};
    }
  }

  static bool can(UserRole role, String permission) {
    return forRole(role).contains(permission);
  }
}
