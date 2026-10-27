# Professional Ecosystem & Appointment Management

This plan implements a complete professional ecosystem including 232 doctors, 58 centers, and advanced management features for appointments and communication.

## User Review Required

- **Data Volume**: 232 doctor accounts and profiles will be seeded.
- **Appointment Logic**: New fields for communication mode (Messaging, Phone, Video) will be added to `SessionRequestModel`.
- **Dashboard Upgrade**: The professional dashboard will be significantly enhanced to manage these new request types.

## Proposed Changes

### 1. Data Models & Seeding

#### [professional_data.dart](file:///home/hafid/Bureau/projetmascara/lib/core/data/professional_data.dart)
- Replace mock data with a generator producing 4 doctors per wilaya (232 total).
- Each doctor will have: Unique Name, Phone (WhatsApp ready), Specialty, and Wilaya.

#### [NEW] [center_data.dart](file:///home/hafid/Bureau/projetmascara/lib/core/data/center_data.dart)
- List of 58 public health centers (EPSP/EPH) corresponding to each Algerian wilaya.

#### [database_seed_service.dart](file:///home/hafid/Bureau/projetmascara/lib/core/data/database_seed_service.dart)
- Update `seed()` to create `UserModel` (Role: Psychologist/Doctor) and `ProfessionalProfile` for all 232 generated doctors.

#### [session_request_model.dart](file:///home/hafid/Bureau/projetmascara/lib/features/professional/models/session_request_model.dart)
- Add `communicationMethod` field (Enum: Messaging, Phone, Video).

---

### 2. User & Professional Features

#### [session_request_page.dart](file:///home/hafid/Bureau/projetmascara/lib/features/professional/screens/session_request_page.dart)
- UI: Add selection for Communication Method.
- Integration: Update submission logic to include the new field.

#### [psychologist_dashboard.dart](file:///home/hafid/Bureau/projetmascara/lib/features/dashboard/psychologist_dashboard.dart)
- UI: Replace "Aucune demande" placeholder with a dynamic list of `SessionRequestModel`.
- Features: Add "Accept/Reject" actions and direct "Start Communication" buttons (WhatsApp link for messaging, Dial for phone).

#### [professional_provider.dart](file:///home/hafid/Bureau/projetmascara/lib/features/professional/professional_provider.dart)
- Add `FutureProvider` for professional sessions.
- Update `search` logic to filter centers from `center_data.dart`.

---

### 4. Account Credentials Pattern

To allow you to test all 232 doctors, I will use a predictable pattern for emails and a common password:

- **Email Pattern**: `dr.[nom].[code_wilaya]@neurosync.dz`
  - Example for Adrar (01): `dr.rahmani.01@neurosync.dz`
  - Example for Alger (16): `dr.moussaoui.16@neurosync.dz`
- **Default Password**: `NeuroSync2024!` (Standard for all seeded professional accounts)

I will generate a full list (CSV or Markdown table) of these accounts once the implementation is complete.

## Verification Plan

### Automated Tests
- `flutter test test/data_seeding_test.dart`: (New) Verify that 232 doctors are correctly created in Hive.

### Manual Verification
1. **Login as Doctor**: Use a generated email (e.g., `doctor1_w01@neurosync.dz`) to log in.
2. **Manage Requests**: View incoming appointment requests on the dashboard.
3. **Communication**: Tap the "WhatsApp" or "Call" button on a request to verify external app launching.
4. **Wilaya Search**: Search for any of the 58 wilayas and confirm 4 doctors and 1 center are listed.
