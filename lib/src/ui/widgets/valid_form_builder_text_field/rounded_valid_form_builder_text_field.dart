import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../constants/ui.dart';
import 'valid_form_builder_text_field.dart';

class RoundedValidFormBuilderTextField extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final int index;
  final String name;
  final String hintText;
  final double borderRadius;
  final FocusNode? focusNode;
  final String? title;
  final String? helperText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? outerSuffix;
  bool obscureText;

  RoundedValidFormBuilderTextField(
      {Key? key,
      required this.formKey,
      required this.index,
      required this.name,
      required this.hintText,
      this.borderRadius = kDefaultRadius,
      this.focusNode,
      this.title,
      this.helperText,
      this.validator,
      this.suffixIcon,
      this.obscureText = false,
      this.outerSuffix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValidFormBuilderTextField(
      formKey: formKey,
      focusNode: focusNode,
      index: index,
      title: title,
      name: name,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        fillColor: Colors.grey[100],
        filled: true,
        hintText: hintText,
        helperStyle: const TextStyle(
          color: kValidColor,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        helperText: helperText,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      outerSuffix: outerSuffix,
    );
  }
}
