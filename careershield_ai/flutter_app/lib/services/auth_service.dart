import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _googleInitialized = false;

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    // google_sign_in v7 on Android requires a server client ID.
    const definedServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
    const fallbackServerClientId =
        '21942538465-4aemfofh7omkrk2oh06asiu43ot7ljc4.apps.googleusercontent.com';
    final serverClientId = definedServerClientId.isNotEmpty
        ? definedServerClientId
        : fallbackServerClientId;
    await _googleSignIn.initialize(
      serverClientId: serverClientId,
    );
    _googleInitialized = true;
  }

  Future<User?> signInWithGoogle() async {
    // Intentionally allow the original exception and stacktrace to surface,
    // but log details to help diagnose Pigeon/platform type issues.
    await _ensureGoogleInitialized();
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth =
      googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      // Log the raw result for debugging (will appear in `flutter run -v` / logcat)
      // Avoiding sensitive token prints; log only types and top-level info.
      // ignore: avoid_print
      print('signInWithCredential result runtimeType=${result.runtimeType}');
      // ignore: avoid_print
      print('user present: ${result.user != null}');

      final User? user = result.user;

      if (user != null) {
        try {
          await _saveUserProfile(user);
        } catch (e, st) {
          // Non-fatal: allow sign-in to succeed even if Firestore is unavailable.
          // Log for diagnostics but don't block user flow.
          // ignore: avoid_print
          print('Google Sign-In profile save failed: $e');
          // ignore: avoid_print
          print(st);
        }
      }

      return user;
    } catch (e, st) {
      // Log full stacktrace to aid diagnosis of Pigeon decoding errors.
      // ignore: avoid_print
      print('Google Sign-In error: $e');
      // ignore: avoid_print
      print(st);
      // Re-throw the original exception so caller/VM shows the full trace.
      rethrow;
    }
  }

  Future<void> _saveUserProfile(User user) async {
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'totalScans': 0,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    try {
      await _ensureGoogleInitialized();
      // ignore: avoid_print
      print('Signing out from Google and Firebase');
      await _googleSignIn.signOut();
      await _auth.signOut();
      // ignore: avoid_print
      print('Sign-out completed');
    } catch (e, st) {
      // ignore: avoid_print
      print('Sign-out error: $e');
      // ignore: avoid_print
      print(st);
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
