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
    this.validator,
    this.suffixIcon,
    this.style,
  });
  final TextEditingController controller;
  final String prefixIcon;
  final String? suffixIcon;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String? value0)? validator;
  final TextStyle? style;

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
        validator: validator,
        style: style,
        onTap: onTap,
        mouseCursor:  readOnly ? SystemMouseCursors.click : MouseCursor.defer,
        decoration: InputDecoration(
          isDense: true,
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
          suffixIcon: suffixIcon == null
              ? null
              : Transform.translate(
                  offset: const Offset(12, 0),
                  child: Transform.scale(
                    scale: 0.18,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        suffixIcon!,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
