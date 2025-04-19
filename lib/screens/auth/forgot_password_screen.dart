import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/button/index.dart';
import '../../bloc/password_reset/index.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../theme/app_theme.dart';
import '../../utils/snackbar_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  static const String resetButtonId = 'reset_password_button';

  @override
  void initState() {
    super.initState();
    // Reset the password reset BLoC state when the screen is opened
    context.read<PasswordResetBloc>().add(const PasswordResetReset());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    // First set the button to loading state just like how Sign Up works
    context.read<ButtonBloc>().add(const ButtonLoading(resetButtonId, true));

    // Then use PasswordResetBloc to handle the password reset request
    context.read<PasswordResetBloc>().add(
      PasswordResetRequested(_emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state.status == PasswordResetStatus.failure) {
          // Reset button loading state
          context.read<ButtonBloc>().add(const ButtonReset(resetButtonId));

          // Show error message using global SnackBar utility
          SnackBarUtils.showErrorSnackBar(
            context,
            state.errorMessage ?? 'Password reset failed',
          );
        } else if (state.status == PasswordResetStatus.loading) {
          // No need to manually set loading state here - this matches Sign Up behavior
        } else if (state.status == PasswordResetStatus.success) {
          // Reset button loading state
          context.read<ButtonBloc>().add(const ButtonReset(resetButtonId));

          // Show success message using global utility
          SnackBarUtils.showSuccessSnackBar(
            context,
            'Password reset link sent',
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppTheme.textPrimaryColor),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child:
                  state.status == PasswordResetStatus.success
                      ? _buildSuccessView(state.email)
                      : _buildResetForm(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forgot Password', style: AppTheme.heading1),
        const SizedBox(height: 8),
        Text(
          'Enter your email and we\'ll send you a link to reset your password',
          style: AppTheme.caption,
        ),
        const SizedBox(height: 32),

        // Email field
        CustomTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 32),

        // Reset password button
        CustomButton(
          id: resetButtonId,
          text: 'Reset Password',
          onPressed: _resetPassword,
        ),
      ],
    );
  }

  Widget _buildSuccessView(String email) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: AppTheme.successColor, size: 80),
        const SizedBox(height: 24),
        Text('Email Sent', style: AppTheme.heading2),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'We have sent a password reset link to $email',
            textAlign: TextAlign.center,
            style: AppTheme.bodyText,
          ),
        ),
        const SizedBox(height: 8),
        Text('Please check your email', style: AppTheme.caption),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Back to Login',
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 200,
        ),
      ],
    );
  }
}
