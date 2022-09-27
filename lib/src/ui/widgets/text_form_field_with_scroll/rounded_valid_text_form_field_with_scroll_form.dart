import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'valid_text_form_field_with_scroll_form.dart';

class RoundedValidTextFormFieldWithScrollFormBlock extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String? title;
  final String name;
  final String? Function(String?)? validator;
  final double? errorTextFontSize;
  final double borderRadius;
  final Color? fillColor;
  final String? hintText;
  final void Function()? onPressed;
  final String buttonTitle;
  final ButtonStyle? buttonStyle;

  const RoundedValidTextFormFieldWithScrollFormBlock(
      {Key? key,
      required this.formKey,
      required this.name,
      required this.borderRadius,
      required this.buttonTitle,
      this.title,
      this.validator,
      this.errorTextFontSize,
      this.fillColor,
      this.hintText,
      this.buttonStyle,
      this.onPressed})
      : assert((validator != null &&
                errorTextFontSize != null &&
                errorTextFontSize >= 0) ||
            validator == null),
        super(key: key);

  @override
  State<RoundedValidTextFormFieldWithScrollFormBlock> createState() =>
      RoundedValidTextFormFieldWithScrollFormBlockState();
}

class RoundedValidTextFormFieldWithScrollFormBlockState
    extends State<RoundedValidTextFormFieldWithScrollFormBlock> {
  @override
  Widget build(BuildContext context) {
    return ValidTextFormFieldWithScrollFormBlock(
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
      ),
      buttonStyle: widget.buttonStyle,
      onPressed: widget.onPressed,
      buttonTitle: widget.buttonTitle,
    );
  }
}
