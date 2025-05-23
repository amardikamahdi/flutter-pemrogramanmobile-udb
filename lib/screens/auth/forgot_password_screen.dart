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
    context.read<PasswordResetBloc>().add(const PasswordResetReset());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    context.read<ButtonBloc>().add(const ButtonLoading(resetButtonId, true));

    context.read<PasswordResetBloc>().add(
      PasswordResetRequested(_emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordResetBloc, PasswordResetState>(
      listener: (context, state) {
        if (state.status == PasswordResetStatus.failure) {
          context.read<ButtonBloc>().add(const ButtonReset(resetButtonId));

          SnackBarUtils.showErrorSnackBar(
            context,
            state.errorMessage ?? 'Pengaturan ulang kata sandi gagal',
          );
        } else if (state.status == PasswordResetStatus.loading) {
        } else if (state.status == PasswordResetStatus.success) {
          context.read<ButtonBloc>().add(const ButtonReset(resetButtonId));

          SnackBarUtils.showSuccessSnackBar(
            context,
            'Tautan atur ulang kata sandi telah dikirim',
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
        Text('Lupa Kata Sandi', style: AppTheme.heading1),
        const SizedBox(height: 8),
        Text(
          'Masukkan alamat email Anda untuk mengatur ulang kata sandi',
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
        const SizedBox(height: 32),

        CustomButton(
          id: resetButtonId,
          text: 'Kirim Tautan Atur Ulang',
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
        Text('Surel terkirim!', style: AppTheme.heading2),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Kami telah mengirimkan tautan atur ulang kata sandi ke $email',
            textAlign: TextAlign.center,
            style: AppTheme.bodyText,
          ),
        ),
        const SizedBox(height: 8),
        Text('Silahkan cek surel anda', style: AppTheme.caption),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Oke',
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 200,
        ),
      ],
    );
  }
}
