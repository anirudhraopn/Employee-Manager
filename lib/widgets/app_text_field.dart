import 'package:employee_manager/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    this.readOnly = false,
    this.onTap,
  });
  final TextEditingController controller;
  final String prefixIcon;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;

  static final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autocorrect: false,
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Transform.scale(
            scale: 0.4,
            child: FittedBox(
              child: SvgPicture.asset(
                prefixIcon,
                height: 24,
                width: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
