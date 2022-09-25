import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_event.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';

class TextFormFieldWithScrollFormBlock extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String name;
  final double verticalPadding;
  final String? Function(String?)? validator;
  final double? errorTextFontSize;
  final InputDecoration decoration;

  const TextFormFieldWithScrollFormBlock({
    Key? key,
    required this.formKey,
    required this.name,
    required this.decoration,
    this.verticalPadding = 0,
    this.validator,
    this.errorTextFontSize,
  })  : assert((validator != null &&
                errorTextFontSize != null &&
                errorTextFontSize >= 0) ||
            validator == null),
        super(key: key);

  @override
  State<TextFormFieldWithScrollFormBlock> createState() =>
      RoundedTextFormFieldState();
}

class RoundedTextFormFieldState
    extends State<TextFormFieldWithScrollFormBlock> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;
  void Function(String? value)? onChanged;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);

    if (widget.validator != null) {
      onChanged = (String? value) {
        if (value == null) {
          return;
        }

        if (value.isEmpty) {
          return;
        }

        if (widget.formKey.currentState?.fields[widget.name]?.errorText !=
            null) {
          widget.formKey.currentState?.fields[widget.name]?.validate();

          if (widget.formKey.currentState!.fields[widget.name]!.isValid) {
            if (_scrollFormWithKeyboardBloc.state
                is ScrollFormWithKeyboardVisible) {
              double scrollHeight = (_scrollFormWithKeyboardBloc.state
                          as ScrollFormWithKeyboardVisible)
                      .scrollHeight -
                  widget.errorTextFontSize!;
              _scrollFormWithKeyboardBloc
                  .add(ErrorTextVisible(scrollHeight: scrollHeight));
            }
          }
        }
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
        child: FormBuilderTextField(
            name: widget.name,
            onEditingComplete: () {
              widget.formKey.currentState?.save();
              widget.formKey.currentState?.validate();
              FocusScope.of(context).unfocus();
            },
            validator: widget.validator,
            decoration: widget.decoration,
            onChanged: onChanged));
  }
}
