import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../bloc/auth/index.dart';
import '../bloc/connectivity/index.dart';
import '../services/api_service.dart';
import '../services/connectivity_service.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isReadyToNavigate = false;
  bool _isCheckingApi = false;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
  }

  Future<void> _checkApiConnection() async {
    if (_isCheckingApi) return;

    setState(() {
      _isCheckingApi = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final isConnected = await ApiService.testConnection();

    if (!mounted) return;

    setState(() {
      _isCheckingApi = false;
      _isReadyToNavigate = true;
    });

    if (isConnected) {
      _checkAuthState();
    } else {
      context.read<ConnectivityBloc>().add(
        ConnectivityChanged(NetworkStatus.offline),
      );
    }
  }

  void _checkAuthState() {
    if (!mounted) return;

    final authBloc = context.read<AuthBloc>();
    authBloc.add(const AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (!_isReadyToNavigate) return;

            if (state.status == AuthStatus.authenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else if (state.status == AuthStatus.unauthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
        ),
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            if (state.status == NetworkStatus.online &&
                _isReadyToNavigate &&
                !_isCheckingApi) {
              _checkApiConnection();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: SafeArea(child: _buildSplashView()),
      ),
    );
  }

  Widget _buildSplashView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Text(
            'CatetIn',
            style: AppTheme.heading1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tugas Pemrograman Mobile',
            style: AppTheme.subtitle.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Amardika Mahdi Pradana - 210103148',
            style: AppTheme.subtitle.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Universitas Duta Bangsa',
            style: AppTheme.subtitle.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 48),
          const SpinKitThreeBounce(color: Colors.white, size: 30.0),
        ],
      ),
    );
  }
}
