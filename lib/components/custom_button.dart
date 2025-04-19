import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double width;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width = double.infinity,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _buildButtonContent(),
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                child: _buildButtonContent(),
              ),
    );
  }

  Widget _buildButtonContent() {
    return isLoading
        ? const SizedBox(
          height: 20,
          width: 20,
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
