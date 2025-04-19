import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/index.dart';
import '../../bloc/button/index.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../components/social_button.dart';
import '../../theme/app_theme.dart';
import '../../utils/snackbar_utils.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static const String loginButtonId = 'login_button';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    // Use Auth BLoC to handle login process, exactly like the register screen
    context.read<AuthBloc>().add(
      LogIn(
        username: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Reset login button loading state
          context.read<ButtonBloc>().add(const ButtonReset(loginButtonId));

          // Show success message and navigate to home
          SnackBarUtils.showSuccessSnackBar(context, 'Login successful');

          // Navigate to home screen (temporarily navigate back to login for demo purposes)
          // In production, replace this with navigation to your actual home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (state.status == AuthStatus.unauthenticated &&
            state.error != null) {
          // Reset login button loading state
          context.read<ButtonBloc>().add(const ButtonReset(loginButtonId));

          // Show error message using the global SnackBar utility
          SnackBarUtils.showErrorSnackBar(context, state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  // Welcome text
                  Text('Welcome Back', style: AppTheme.heading1),
                  const SizedBox(height: 8),
                  Text('Sign in to continue', style: AppTheme.caption),
                  const SizedBox(height: 32),

                  // Email field
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  CustomButton(
                    id: loginButtonId,
                    text: 'Sign In',
                    onPressed: () => _login(context),
                  ),
                  const SizedBox(height: 24),

                  // OR divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: AppTheme.caption),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social login buttons
                  SocialButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () {
                      // TODO: Implement Google Sign-In
                    },
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Continue with Facebook',
                    icon: Icons.facebook,
                    onPressed: () {
                      // TODO: Implement Facebook Sign-In
                    },
                  ),
                  const SizedBox(height: 32),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTheme.caption),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
