import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTheme.subtitle.copyWith(
            fontSize: 16,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          enabled: widget.enabled,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(
                      widget.prefixIcon,
                      color: AppTheme.textSecondaryColor,
                    )
                    : null,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: AppTheme.textSecondaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : null,
          ),
          style: AppTheme.bodyText,
        ),
      ],
    );
  }
}
