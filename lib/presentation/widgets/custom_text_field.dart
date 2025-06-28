import 'package:flutter/material.dart';
import 'package:pocket_tasks/core/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController noteController,
    this.labelText,
    this.maxLines,
  }) : _noteController = noteController;

  final TextEditingController _noteController;
  final int? maxLines;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _noteController,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorsConst.kPurple, width: 1),
        ),
      ),
    );
  }
}
