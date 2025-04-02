import 'package:employee_manager/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor:
            !isPrimary ? AppColors.primaryLight : AppColors.primaryColor,
        foregroundColor:
            isPrimary ? Colors.white : AppColors.primaryColor,
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}
