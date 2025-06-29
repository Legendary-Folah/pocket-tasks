import 'package:flutter/material.dart';
import 'package:pocket_tasks/core/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.labelText,
    this.maxLines,
    this.initialValue,
    this.controller,
  });

  final int? maxLines;
  final String? labelText;
  final String? initialValue;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      initialValue: initialValue,
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
