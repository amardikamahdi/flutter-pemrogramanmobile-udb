import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate password reset process
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isEmailSent = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: _isEmailSent ? _buildSuccessView() : _buildResetForm(),
        ),
      ),
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Reset password button
          CustomButton(
            text: 'Reset Password',
            onPressed: _resetPassword,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
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
            'We have sent a password reset link to ${_emailController.text}',
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
