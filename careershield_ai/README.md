# CareerShield AI

CareerShield AI is an AI-powered platform that helps students detect fake job and internship scams while also giving career intelligence through skill-gap analysis and learning roadmaps.

## Stack

- Flutter mobile app
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Functions
- Python Flask ML backend
- Google Gemini API

## Project Structure

```text
careershield_ai/
- flutter_app/
- firebase_functions/
- ml_backend/
- README.md
```

## Setup

### 1. Python backend

```bash
cd ml_backend
pip install -r requirements.txt
```

Create a `.env` file inside `ml_backend`:

```env
GEMINI_API_KEY=your_gemini_api_key
```

You can start the backend even before training the model. In that case it uses a fallback heuristic scorer so the API and Flutter flow are still testable.

Train the model after downloading the dataset:

```bash
python train_model.py
```

Run the API:

```bash
python app.py
```

Health check:

```bash
curl http://localhost:8080/health
```

### 2. Firebase Functions

```bash
cd firebase_functions
npm install
```

Create `.env` from `.env.example` and set `ML_BACKEND_URL`.

For local Firebase development from the repo root:

```bash
firebase emulators:start
```

### 3. Flutter app

```bash
cd flutter_app
flutter pub get
```

Replace placeholder Firebase values in `lib/firebase_options.dart` with your real project configuration, or run:

```bash
flutterfire configure
```

If you have not initialized Flutter in this folder yet, create the platform folders first:

```bash
flutter create .
```

Then start the app:

```bash
flutter run
```

## Notes

- `.gitignore`, `firebase.json`, Firestore rules, and index definitions are included now.
- `model.pkl` and `vectorizer.pkl` are generated after training and are not committed yet.
- `google-services.json` and iOS Firebase config files still need to be added from your Firebase project.
- The mobile app expects authenticated Firebase users before calling the backend functions.
- `flutter_app/lib/firebase_options.dart` still contains placeholder values until you run `flutterfire configure`.
