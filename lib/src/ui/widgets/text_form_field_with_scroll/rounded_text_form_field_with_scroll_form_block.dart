import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'text_form_field_with_scroll_form_block.dart';

class RoundedTextFormFieldWithScrollFormBlock extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String? title;
  final String name;
  final String? Function(String?)? validator;
  final double? errorTextFontSize;
  final double borderRadius;
  final Color? fillColor;
  final String? hintText;

  const RoundedTextFormFieldWithScrollFormBlock(
      {Key? key,
      required this.formKey,
      required this.name,
      required this.borderRadius,
      this.title,
      this.validator,
      this.errorTextFontSize,
      this.fillColor,
      this.hintText})
      : assert((validator != null &&
                errorTextFontSize != null &&
                errorTextFontSize >= 0) ||
            validator == null),
        super(key: key);

  @override
  State<RoundedTextFormFieldWithScrollFormBlock> createState() =>
      RoundedTextFormFieldWithScrollFormBlockState();
}

class RoundedTextFormFieldWithScrollFormBlockState
    extends State<RoundedTextFormFieldWithScrollFormBlock> {
  @override
  Widget build(BuildContext context) {
    return TextFormFieldWithScrollFormBlock(
        formKey: widget.formKey,
        title: widget.title,
        name: widget.name,
        validator: widget.validator,
        errorTextFontSize: widget.errorTextFontSize,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          fillColor: widget.fillColor,
          filled: widget.fillColor != null ? true : false,
          hintText: widget.hintText,
        ));
  }
}
