import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../bloc/button/index.dart';

class CustomButton extends StatelessWidget {
  final String id;
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final double width;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.width = double.infinity,
    this.icon,
    String? id,
  }) : id = id ?? text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonBloc, ButtonState>(
      builder: (context, state) {
        final isLoading = state.isLoading(id);

        return SizedBox(
          width: width,
          child:
              isOutlined
                  ? OutlinedButton(
                    onPressed: isLoading ? null : _handlePress(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppTheme.primaryColor,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: Colors.transparent,
                      disabledForegroundColor: AppTheme.primaryColor
                          .withOpacity(0.8),
                    ),
                    child: _buildButtonContent(isLoading),
                  )
                  : ElevatedButton(
                    onPressed: isLoading ? null : _handlePress(context),
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: AppTheme.primaryColor,
                      disabledForegroundColor: Colors.white,
                    ),
                    child: _buildButtonContent(isLoading),
                  ),
        );
      },
    );
  }

  VoidCallback _handlePress(BuildContext context) {
    return () {
      context.read<ButtonBloc>().add(ButtonLoading(id, true));

      onPressed();
    };
  }

  Widget _buildButtonContent(bool isLoading) {
    return isLoading
        ? const SizedBox(
          height: 19,
          width: 19,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(text),
          ],
        );
  }
}
