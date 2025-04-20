import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/button/index.dart';
import '../bloc/connectivity/index.dart';
import '../components/custom_button.dart';
import '../theme/app_theme.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  static const String retryButtonId = 'network_retry_button';

  void _retryConnection(BuildContext context) {
    context.read<ButtonBloc>().add(const ButtonLoading(retryButtonId, true));
    context.read<ConnectivityBloc>().add(const ConnectivityRequested());

    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<ButtonBloc>().add(const ButtonReset(retryButtonId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Connection Problem',
                  style: AppTheme.heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We couldn\'t connect to our servers. Please check your internet connection and try again.',
                  style: AppTheme.subtitle.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    id: retryButtonId,
                    text: 'Try Again',
                    onPressed: () => _retryConnection(context),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Waiting for connection...',
                  style: AppTheme.caption.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
