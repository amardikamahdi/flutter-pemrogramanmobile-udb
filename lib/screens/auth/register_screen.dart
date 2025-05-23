import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/index.dart';
import '../../bloc/button/index.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../components/social_button.dart';
import '../../theme/app_theme.dart';
import '../../utils/snackbar_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  static const String registerButtonId = 'register_button';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    if (_passwordController.text != _confirmPasswordController.text) {
      SnackBarUtils.showErrorSnackBar(context, 'Kata sandi tidak cocok');
      return;
    }

    context.read<AuthBloc>().add(
      SignUp(
        username: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.read<ButtonBloc>().add(const ButtonReset(registerButtonId));

          SnackBarUtils.showSuccessSnackBar(context, 'Pendaftaran berhasil');

          Navigator.pop(context);
        } else if (state.status == AuthStatus.unauthenticated &&
            state.error != null) {
          context.read<ButtonBloc>().add(const ButtonReset(registerButtonId));

          SnackBarUtils.showErrorSnackBar(context, state.error!);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppTheme.textPrimaryColor),
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daftar', style: AppTheme.heading1),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan data diri anda untuk melanjutkan',
                    style: AppTheme.caption,
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

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

                  CustomTextField(
                    label: 'Konfirmasi Kata Sandi',
                    hint: 'Masukkan kata sandi lagi',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    id: registerButtonId,
                    text: 'Daftar',
                    onPressed: () => _register(context),
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
                    label: 'Daftar dengan Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Daftar dengan Facebook',
                    icon: Icons.facebook,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun?", style: AppTheme.caption),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Masuk',
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
