## Google Sign-In Android Fix

Use this when login fails with `ApiException: 10` / `DEVELOPER_ERROR`.

### 1) Firebase Console checks

- Open Firebase Console for project `careershield-1f184`.
- Go to Authentication -> Sign-in method -> Google, and ensure it is enabled.
- Go to Project settings -> Your apps -> Android app `com.example.careershield_ai`.
- Add these fingerprints for your current debug keystore:
  - SHA-1: `B8:12:E3:4A:57:93:13:D1:20:4A:F4:AC:F6:FC:6D:59:64:BC:99:87`
  - SHA-256: `DA:A0:12:13:E6:3F:3A:42:7A:18:CD:86:33:56:8C:DD:0C:7A:34:EA:12:2C:0F:36:62:EB:87:4E:02:FF:57:A3`

### 2) Replace Android Firebase config

- Download a fresh `google-services.json` from Firebase after saving fingerprints.
- Replace `android/app/google-services.json` with the downloaded file.

### 3) Validate before rerun

- Ensure `android/app/google-services.json` contains a non-empty `oauth_client` for `com.example.careershield_ai`.
- Ensure app id still matches `android/app/build.gradle.kts`:
  - `applicationId = "com.example.careershield_ai"`

### 4) Rebuild

Run:

```powershell
flutter clean
flutter pub get
flutter run -d 10BE4R0EC200096
```
