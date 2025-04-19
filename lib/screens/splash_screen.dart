import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
