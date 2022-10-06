import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_event.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';
import '../../../constants/ui.dart';

class TextFormFieldWithScrollFormBlock extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String? title;
  final String name;
  final String? Function(String?)? validator;
  final void Function(String? value)? onChanged;
  final double? errorTextFontSize;
  final InputDecoration decoration;

  const TextFormFieldWithScrollFormBlock({
    Key? key,
    required this.formKey,
    required this.name,
    required this.decoration,
    this.title,
    this.validator,
    this.onChanged,
    this.errorTextFontSize,
  })  : assert((validator != null &&
                errorTextFontSize != null &&
                errorTextFontSize >= 0) ||
            validator == null),
        super(key: key);

  @override
  State<TextFormFieldWithScrollFormBlock> createState() =>
      TextFormFieldWithScrollFormBlockState();
}

class TextFormFieldWithScrollFormBlockState
    extends State<TextFormFieldWithScrollFormBlock> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;
  late FocusNode focusNode;

  void emitScrollEventForShowingButtonWhenKeyboardVisible() {
    if (_scrollFormWithKeyboardBloc.state is ScrollFormWithKeyboardEmpty ||
        _scrollFormWithKeyboardBloc.state is ScrollFormWithKeyboardVisible) {
      String? label = FocusScope.of(context).focusedChild?.debugLabel;

      if (label == null) {
        return;
      }

      int? length = widget.formKey.currentState?.fields.keys.toList().length;
      int? index =
          widget.formKey.currentState?.fields.keys.toList().indexOf(label);

      if (index == null || length == null) {
        return;
      }

      if (length == 2) {
        _scrollFormWithKeyboardBloc.add(KeyboardVisible());
        return;
      }

      if (index == 0) {
        return;
      }
      if (index == length - 2 || index == length - 1) {
        _scrollFormWithKeyboardBloc.add(KeyboardVisible());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
    focusNode = FocusNode(debugLabel: widget.name);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        emitScrollEventForShowingButtonWhenKeyboardVisible();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.title == null
        ? FormBuilderTextField(
            name: widget.name,
            focusNode: focusNode,
            onChanged: widget.onChanged,
            onEditingComplete: () {
              widget.formKey.currentState?.save();
              bool? isValid =
                  widget.formKey.currentState?.fields[widget.name]?.validate();

              if (isValid == null) return;
              if (isValid == false) return;
              FocusScope.of(context).nextFocus();
            },
            textInputAction:
                widget.formKey.currentState?.fields[widget.name]?.isValid ==
                        null
                    ? TextInputAction.next
                    : widget.formKey.currentState!.fields[widget.name]!.isValid
                        ? TextInputAction.done
                        : TextInputAction.next,
            validator: widget.validator,
            decoration: widget.decoration,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  widget.title!,
                  style: const TextStyle(
                      fontSize: kDefaultTextFormFieldTitleFontSize),
                ),
                const SizedBox(
                  height: kDefaultLetterSpacingBetweenTitleAndForm,
                ),
                FormBuilderTextField(
                  name: widget.name,
                  focusNode: focusNode,
                  onChanged: widget.onChanged,
                  onEditingComplete: () {
                    widget.formKey.currentState?.save();

                    bool? isValid = widget
                        .formKey.currentState?.fields[widget.name]
                        ?.validate();

                    if (isValid == null) return;
                    if (isValid == false) return;

                    FocusScope.of(context).nextFocus();
                  },
                  textInputAction: widget.formKey.currentState
                              ?.fields[widget.name]?.isValid ==
                          null
                      ? TextInputAction.next
                      : widget.formKey.currentState!.fields[widget.name]!
                              .isValid
                          ? TextInputAction.done
                          : TextInputAction.next,
                  validator: widget.validator,
                  decoration: widget.decoration,
                )
              ]);
  }
}
