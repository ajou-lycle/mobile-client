import 'package:flutter/material.dart';

class RoundedTextFormField extends StatefulWidget {
  final double verticalPadding;
  final String? Function(String?)? validator;
  final double borderRadius;
  final Color? fillColor;
  final String? hintText;

  const RoundedTextFormField(
      {Key? key,
      this.verticalPadding = 0,
      this.validator,
      required this.borderRadius,
      this.fillColor,
      this.hintText})
      : super(key: key);

  @override
  State<RoundedTextFormField> createState() => RoundedTextFormFieldState();
}

class RoundedTextFormFieldState extends State<RoundedTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
        child: TextFormField(
          validator: widget.validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            fillColor: widget.fillColor,
            filled: widget.fillColor != null ? true : false,
            hintText: widget.hintText,
          ),
        ));
  }
}
