# Phase 3 Implementation Plan - Advanced Administration & Global Management

This plan outlines the steps to transform the Admin account into a comprehensive management center for NeuroSync 4.0. It includes dashboard statistics, professional/user management, security logs, and PDF export functionality.

## User Review Required

- **Privacy Constraint**: The Admin is an administrative role and does NOT have automatic access to clinical patient data. Only account status, metadata, and high-level activity logs are visible to the Admin.
- **PDF Dependencies**: I will add `pdf`, `printing`, and `path_provider` to `pubspec.yaml` to handle real PDF generation.

## Proposed Changes

### 1. Core Models & Infrastructure

- **[NEW] SecurityLog Model**: Define `SecurityLog` (actorId, action, targetId, timestamp, metadata) to track administrative and security events.
- **[NEW] SecurityLog Repository**: Implement `SecurityLogRepository` and `MockSecurityLogService` with Hive persistence (encrypted box).
- **[NEW] Admin Repository**: Implement `AdminRepository` to provide global statistics derived from **persisted records** (total users, professional statuses, assessment counts).
    - > [!IMPORTANT]
    - > Statistics will be computed directly from `UserModel` and `AssessmentRecord` Hive boxes, NOT recalculated via `DeterministicDecisionEngine`.

### 2. Admin Dashboard & Management Screens

- **Admin Dashboard Enhancement**: Replace the basic list with a modern dashboard featuring statistics cards and navigation.
- **[NEW] Professional Management Screen**: List of professionals grouped by status (Pending, Approved, Rejected) with search and filter capabilities.
- **[NEW] Professional Detail Screen**: Detailed view for reviewing and approving/rejecting professional accounts.
- **[NEW] User Management Screen**: Administrative view of user accounts with status management (Activate/Suspend).
- **[NEW] User Detail Screen**: Overview of user account information (Metadata only, no clinical details).
- **[NEW] Security Logs Screen**: Searchable and filterable list of security events.
- **[NEW] Admin Settings Screen**: Global system settings.

### 3. Clinical Report PDF Export

- **PDF Generation logic**: Implement a generator that handles:
    - Multi-language support (FR/AR).
    - **RTL layout** for Arabic.
    - **Unicode support** for Arabic characters (using custom fonts like Noto Sans Arabic).
- **Clinical Report Screen Update**: Add a "Download PDF" action that triggers the generator.

### 4. Routing & Security

- **GoRouter Updates**: Add protected routes for all new admin screens under `/admin`.
- **Enhanced Guards**: Verify that:
    - Guests/Users/Psychologists are redirected to their respective dashboards if they attempt to access `/admin`.
    - Pending professionals are restricted from professional-only features.

### 5. Internationalization & RTL

- **L10n Updates**: Add administrative strings to `app_fr.arb` and `app_ar.arb`.
- **L10n Helper Extension**: Update `translate` extension to support new keys.

## Verification Plan

### Automated Tests
- **Unit Tests**:
    - `SecurityLogRepository` persistence and retrieval.
    - `AdminRepository` statistics calculation logic (ensuring it uses persisted Hive data).
    - **PDF Generator Test**: Verify content rendering and metadata extraction.
- **Widget Tests**:
    - Admin Dashboard rendering.
    - **Routing Guards Matrix**:
        - Guest -> `/admin` (Denied)
        - User -> `/admin` (Denied)
        - Psychologist -> `/admin` (Denied)
        - Admin -> `/admin` (Allowed)

### Manual Verification
- **Admin Workflow**: Login as admin, approve a professional, check if stats update, and verify the security log entry.
- **PDF Export**: Generate a report in both French and Arabic and verify layout, RTL support, and Unicode character rendering.
- **Responsive Check**: Test screens on mobile and desktop viewports.
