import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../utils/colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        final message = _mapSignInError(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapSignInError(Object error) {
    final text = error.toString();
    final lower = text.toLowerCase();

    if (error is FirebaseAuthException) {
      if (error.code == 'network-request-failed') {
        return 'Sign in failed: Network issue. Check your internet and try again.';
      }
      if (error.code == 'account-exists-with-different-credential') {
        return 'Sign in failed: This email already uses another sign-in method.';
      }
      return 'Sign in failed: ${error.message ?? error.code}';
    }

    if (error is PlatformException) {
      // ApiException 10 / developer_error usually means missing SHA fingerprint
      // or OAuth client mismatch in Firebase project settings.
      if (lower.contains('apiexception: 10') || lower.contains('developer_error')) {
        return 'Sign in failed: Google OAuth is misconfigured. Add SHA-1/SHA-256 for this Android app in Firebase and download a new google-services.json.';
      }
      if (lower.contains('sign_in_canceled') || lower.contains('cancel')) {
        return 'Sign in cancelled.';
      }
    }

    if (lower.contains('network')) {
      return 'Sign in failed: Network issue. Check your internet and try again.';
    }

    return 'Sign in failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 70,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'CareerShield AI',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your intelligent shield against\njob scams and career uncertainty',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              const Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                children: [
                  _FeaturePill(icon: Icons.security, label: 'Scam Detect'),
                  _FeaturePill(icon: Icons.trending_up, label: 'Skill Gap'),
                  _FeaturePill(icon: Icons.analytics, label: 'Career AI'),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.login_rounded),
                  label: Text(
                    _isLoading ? 'Signing in...' : 'Continue with Google',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'By signing in, you agree to our Terms & Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeaturePill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
 
