import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String? iconPath;
  final IconData? icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconPath,
    this.icon,
  }) : assert(
         iconPath != null || icon != null,
         'Either iconPath or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimaryColor,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset(iconPath!, height: 24, width: 24),
            )
          else if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(icon!, size: 24, color: AppTheme.textPrimaryColor),
            ),
          Text(
            label,
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
