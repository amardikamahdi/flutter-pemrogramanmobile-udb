import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A utility class for displaying SnackBars consistently throughout the app.
class SnackBarUtils {
  /// Shows an error message as a SnackBar at the bottom of the screen
  static void showErrorSnackBar(BuildContext context, String message) {
    // Dismiss any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        // Use fixed behavior to ensure it appears at the bottom bar
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows a success message as a SnackBar at the bottom of the screen
  static void showSuccessSnackBar(BuildContext context, String message) {
    // Dismiss any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        // Use fixed behavior to ensure it appears at the bottom bar
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows an info message as a SnackBar at the bottom of the screen
  static void showInfoSnackBar(BuildContext context, String message) {
    // Dismiss any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        // Use fixed behavior to ensure it appears at the bottom bar
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
