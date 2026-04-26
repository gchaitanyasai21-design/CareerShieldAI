# CareerShield AI Windows Setup

This guide gets the project running locally on Windows in the safest order.

## 1. Install required tools

Install these first:

- Flutter SDK
- Python 3.11 or 3.12
- Node.js 20+
- Firebase CLI
- Git
- Android Studio

Recommended checks after install:

```powershell
flutter --version
python --version
node --version
npm --version
firebase --version
git --version
```

## 2. Fix Flutter tooling

Run:

```powershell
flutter doctor
```

Make sure these are green or resolved:

- Flutter SDK
- Android toolchain
- Android Studio
- VS Code or another editor
- Connected device or emulator

If needed, accept Android licenses:

```powershell
flutter doctor --android-licenses
```

## 3. Create the Python environment

From the project root:

```powershell
cd "e:\Careershield AI\careershield_ai\ml_backend"
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Create `.env` from `.env.example`:

```powershell
Copy-Item .env.example .env
```

Then add your real Gemini key:

```env
GEMINI_API_KEY=your_real_gemini_api_key
```

## 4. Start the backend once before training

This project can boot with fallback scoring even before the ML model is trained.

```powershell
cd "e:\Careershield AI\careershield_ai\ml_backend"
.\.venv\Scripts\Activate.ps1
python app.py
```

Open this in a browser:

```text
http://localhost:8080/health
```

Expected result:

- `status` should say the API is running
- `model_ready` will probably be `false` until you train the model

## 5. Set up Firebase

Login:

```powershell
firebase login
```

From the repo root:

```powershell
cd "e:\Careershield AI\careershield_ai"
Copy-Item .firebaserc.example .firebaserc
```

Edit `.firebaserc` and replace the placeholder project ID with your real Firebase project ID.

## 6. Install Firebase Functions dependencies

```powershell
cd "e:\Careershield AI\careershield_ai\firebase_functions"
npm install
Copy-Item .env.example .env
```

Set the backend URL in `firebase_functions/.env`:

```env
ML_BACKEND_URL=http://localhost:8080
```

## 7. Configure Firestore

In Firebase Console:

- enable Authentication
- enable Google Sign-In
- create Firestore database

Then from repo root you can deploy rules later with:

```powershell
firebase deploy --only firestore:rules,firestore:indexes
```

## 8. Initialize Flutter app dependencies

```powershell
cd "e:\Careershield AI\careershield_ai\flutter_app"
flutter pub get
```

If this folder is not yet a full Flutter app on your machine, run:

```powershell
flutter create .
flutter pub get
```

Important:

- if `flutter create .` asks about overwriting files, review carefully
- your current `lib/` code should be preserved, but avoid replacing custom files blindly

## 9. Connect Flutter to Firebase

Install FlutterFire CLI if needed:

```powershell
dart pub global activate flutterfire_cli
```

Then run:

```powershell
cd "e:\Careershield AI\careershield_ai\flutter_app"
flutterfire configure
```

This should update:

- `lib/firebase_options.dart`
- Android Firebase config integration
- iOS config if selected

Also make sure these files are added from Firebase if needed:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## 10. Run Firebase emulators for local testing

From repo root:

```powershell
cd "e:\Careershield AI\careershield_ai"
firebase emulators:start
```

This starts local services configured in `firebase.json`.

## 11. Run the Flutter app

Start an Android emulator or connect a device, then:

```powershell
cd "e:\Careershield AI\careershield_ai\flutter_app"
flutter run
```

At this stage:

- Google Sign-In should work once Firebase is configured
- scam detection should work through the fallback backend
- skill-gap flow should work

## 12. Train the real ML model

Download the Kaggle fake job postings dataset and place it here:

```text
e:\Careershield AI\careershield_ai\ml_backend\fake_job_postings.csv
```

Then run:

```powershell
cd "e:\Careershield AI\careershield_ai\ml_backend"
.\.venv\Scripts\Activate.ps1
python train_model.py
```

Expected outputs:

- `model.pkl`
- `vectorizer.pkl`

Restart the Flask server after training:

```powershell
python app.py
```

Now `http://localhost:8080/health` should report:

- `model_ready: true`

## 13. Recommended first test flow

Test in this order:

1. Open backend health endpoint
2. Start Firebase emulators
3. Launch Flutter app
4. Sign in with Google
5. Paste a suspicious job post into scam detector
6. Run a skill-gap analysis
7. Open history screen

## 14. Common issues

### Flutter not found

Add Flutter `bin` to PATH, then reopen terminal.

### Python not found

Reinstall Python and enable the option to add Python to PATH.

### Firebase init errors

Run `flutterfire configure` again and verify the correct Firebase project.

### Google Sign-In fails

Check:

- Firebase Authentication has Google enabled
- SHA-1 is added for Android
- `google-services.json` is from the correct project

### Backend starts but predictions are weak

That is expected until you train the real model. The fallback scorer is only for local bring-up.

## 15. Best next development tasks

After local setup works, the next best improvements are:

1. Add API request logging and error states
2. Improve Flutter UI polish and loading states
3. Add tests for Flask endpoints and Dart services
4. Replace static career data with Firestore or admin-managed content
5. Deploy backend and Firebase services
