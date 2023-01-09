import 'package:admin_side/constants.dart';
import 'package:admin_side/views/widgets/buttons.dart';
import 'package:flutter/material.dart';

class SimpleFormInput extends StatelessWidget {
  final ActionRSIS? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final ActionRVIS? onChanged;
  const SimpleFormInput({
    super.key,
    this.validator,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: kTextFormFieldStyle(),
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
      ),
      onChanged: onChanged,
      // The validator receives the text that the user has entered.
      validator: validator,
    );
  }
}
