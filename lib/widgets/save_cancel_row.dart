import 'package:employee_manager/widgets/app_button.dart';
import 'package:flutter/material.dart';

class SaveCancelRow extends StatelessWidget {
  const SaveCancelRow({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  final VoidCallback onSave, onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          text: 'Cancel',
          onTap: onCancel,
          isPrimary: false,
        ),
        const SizedBox(
          width: 8,
        ),
        AppButton(
          text: 'Save',
          onTap: () => onSave(),
        )
      ],
    );
  }
}