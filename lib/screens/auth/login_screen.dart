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
    context.read<ButtonBloc>().add(const ButtonLoading(loginButtonId, true));

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
          context.read<ButtonBloc>().add(const ButtonReset(loginButtonId));

          SnackBarUtils.showSuccessSnackBar(context, 'Login successful');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else if (state.status == AuthStatus.unauthenticated &&
            state.error != null) {
          context.read<ButtonBloc>().add(const ButtonReset(loginButtonId));

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

                  Text('Selamat datang', style: AppTheme.heading1),
                  const SizedBox(height: 8),
                  Text(
                    'Silahkan masuk untuk melanjutkan',
                    style: AppTheme.caption,
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: 'Surel',
                    hint: 'Masukkan surel anda',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Kata Sandi',
                    hint: 'Masukkan kata sandi',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),

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
                        'Lupa Kata Sandi?',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    id: loginButtonId,
                    text: 'Masuk',
                    onPressed: () => _login(context),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Atau', style: AppTheme.caption),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SocialButton(
                    label: 'Lanjutkan dengan Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Lanjutkan dengan Facebook',
                    icon: Icons.facebook,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Tidak memiliki akun? ", style: AppTheme.caption),
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
                          'Daftar',
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
