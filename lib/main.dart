import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/button/index.dart';
import 'bloc/auth/index.dart';
import 'bloc/connectivity/index.dart';
import 'bloc/password_reset/index.dart';
import 'bloc/theme/index.dart';
import 'screens/network_error_screen.dart';
import 'services/connectivity_service.dart';
import 'theme/app_theme.dart';
import 'screens/app_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final connectivityService = ConnectivityService();
  connectivityService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ButtonBloc>(create: (context) => ButtonBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<PasswordResetBloc>(
          create: (context) => PasswordResetBloc(),
        ),
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      ],
      child: const AppWithConnectivity(),
    );
  }
}

class AppWithConnectivity extends StatelessWidget {
  const AppWithConnectivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivityState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Your App Name',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home:
                  connectivityState.shouldShowErrorScreen &&
                          connectivityState.status == NetworkStatus.offline
                      ? const NetworkErrorScreen()
                      : const ConnectivityOverlayWrapper(child: AppContainer()),
            );
          },
        );
      },
    );
  }
}

class ConnectivityOverlayWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityOverlayWrapper({super.key, required this.child});

  @override
  State<ConnectivityOverlayWrapper> createState() =>
      _ConnectivityOverlayWrapperState();
}

class _ConnectivityOverlayWrapperState
    extends State<ConnectivityOverlayWrapper> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (!state.shouldShowErrorScreen) {
          _removeConnectionOverlay();

          if (state.status == NetworkStatus.offline) {
            _showNoConnectionOverlay();
          } else if (state.status == NetworkStatus.online) {
            _showConnectionRestoredOverlay();
          }
        }
      },
      child: widget.child,
    );
  }

  void _showNoConnectionOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              color: Colors.red.shade700,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No Internet Connection',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: _removeConnectionOverlay,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Overlay.of(context).insert(_overlayEntry!);

        Future.delayed(const Duration(seconds: 5), () {
          _removeConnectionOverlay();
        });
      }
    });
  }

  void _showConnectionRestoredOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            right: 10,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(10),
              color: Colors.green.shade700,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi, color: Colors.white),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Internet Connection Restored',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: _removeConnectionOverlay,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Overlay.of(context).insert(_overlayEntry!);

        Future.delayed(const Duration(seconds: 3), () {
          _removeConnectionOverlay();
        });
      }
    });
  }

  void _removeConnectionOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeConnectionOverlay();
    super.dispose();
  }
}
