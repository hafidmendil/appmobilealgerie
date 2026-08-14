# Implementation Plan - Phase 1: Stabilization & Corrections

This plan addresses the critical stabilization and security issues identified in the NeuroSync 4.0 audit.

## User Review Required

> [!IMPORTANT]
> - **Role Detection Change**: Roles are no longer detected by email content (e.g., "admin" in email). You must now explicitly select the role during registration. For existing mock data, users must be registered via the `register` method or added to the `users_box` with their respective roles.
> - **Encryption**: All Hive boxes now require an encryption key. If you have existing unencrypted boxes in your local environment, they might fail to open. You may need to clear app data once to reset the boxes with encryption.

## Proposed Changes

### Assessment Engine

#### [adaptive_assessment_engine.dart](file:///home/hafid/Bureau/projetmascara/lib/features/engine/adaptive_assessment_engine.dart)
- Fix `OrientationResult` construction to include `summaryKey` and `moduleScores`.
- Align logic with `DeterministicDecisionEngine` for consistency.

### Authentication & Roles

#### [mock_auth_service.dart](file:///home/hafid/Bureau/projetmascara/lib/core/services/mock_auth_service.dart)
- Remove `email.contains('admin')` logic.
- Implement explicit role storage and retrieval from `users_box`.
- Fix `HiveObject` conflict by using `.copyWith()` when storing the same user in multiple boxes.

### Persistence & Security

#### [mock_assessment_repository.dart](file:///home/hafid/Bureau/projetmascara/lib/core/services/mock_assessment_repository.dart)
#### [mock_professional_service.dart](file:///home/hafid/Bureau/projetmascara/lib/core/services/mock_professional_service.dart)
#### [sync_service.dart](file:///home/hafid/Bureau/projetmascara/lib/core/services/sync_service.dart)
#### [assessment_state.dart](file:///home/hafid/Bureau/projetmascara/lib/features/assessment/assessment_state.dart)
- Update all `Hive.openBox` calls to use `HiveConfig.getEncryptionCipher()`.

---

## Verification Plan

### Automated Tests
- `flutter test test/adaptive_engine_test.dart`
- `flutter test test/auth_repository_test.dart`
- `flutter test test/engine_test.dart`

### Manual Verification
- Run the app and verify that Guest and User workflows still work.
- Register as a Psychologist and verify the `pending` status.
- Verify that accessing `/admin` with a standard User role redirects to `/user`.
