import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../bloc/auth/index.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isReadyToNavigate = false;

  @override
  void initState() {
    super.initState();

    // Trigger authentication check immediately
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const AppStarted());

    // But ensure we don't navigate away until minimum display time is reached
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isReadyToNavigate = true;

          // After delay, check current auth state and navigate if needed
          _checkAuthStateAndNavigate();
        });
      }
    });
  }

  // Helper method to check auth state and navigate
  void _checkAuthStateAndNavigate() {
    if (!mounted) return;

    final currentState = context.read<AuthBloc>().state;

    if (currentState.status == AuthStatus.authenticated) {
      // Navigate to the home screen (instead of Placeholder)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) =>
                  const LoginScreen(), // Temporarily using LoginScreen until a proper home screen is created
        ),
      );
    } else if (currentState.status == AuthStatus.unauthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
    // If status is still unknown, wait for BlocListener to handle it
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Only navigate if minimum display time has passed
        if (!_isReadyToNavigate) return;

        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder:
                  (context) =>
                      const LoginScreen(), // Temporarily using LoginScreen until a proper home screen is created
            ),
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon (replace with your own asset)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // App name
                Text(
                  'Your App Name',
                  style: AppTheme.heading1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                // App tagline
                Text(
                  'Your App Tagline Here',
                  style: AppTheme.subtitle.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 48),
                // Loading indicator
                const SpinKitThreeBounce(color: Colors.white, size: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
