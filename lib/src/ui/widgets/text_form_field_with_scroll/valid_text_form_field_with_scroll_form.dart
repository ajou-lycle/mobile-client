import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:lycle/src/constants/ui.dart';

import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_bloc.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_event.dart';
import '../../../bloc/scroll_form_with_keyboard/scroll_form_with_keyboard_state.dart';

class ValidTextFormFieldWithScrollFormBlock extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final String? title;

  final String name;

  final String? Function(String?)? validator;
  final double? errorTextFontSize;
  final InputDecoration decoration;

  final ButtonStyle? buttonStyle;
  final void Function()? onPressed;
  final String buttonTitle;

  const ValidTextFormFieldWithScrollFormBlock(
      {Key? key,
      required this.formKey,
      required this.name,
      required this.decoration,
      required this.buttonTitle,
      this.title,
      this.validator,
      this.errorTextFontSize,
      this.buttonStyle,
      this.onPressed})
      : assert((validator != null &&
                errorTextFontSize != null &&
                errorTextFontSize >= 0) ||
            validator == null),
        super(key: key);

  @override
  State<ValidTextFormFieldWithScrollFormBlock> createState() =>
      ValidTextFormFieldWithScrollFormBlockState();
}

class ValidTextFormFieldWithScrollFormBlockState
    extends State<ValidTextFormFieldWithScrollFormBlock> {
  late ScrollFormWithKeyboardBloc _scrollFormWithKeyboardBloc;
  late FocusNode focusNode;
  void Function(String? value)? onChanged;

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

      if (index == length - 2 || index == length - 1) {
        _scrollFormWithKeyboardBloc.add(KeyboardVisible(
            scrollHeight: _scrollFormWithKeyboardBloc.scrollHeight));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollFormWithKeyboardBloc =
        BlocProvider.of<ScrollFormWithKeyboardBloc>(context);
    focusNode = FocusNode(debugLabel: widget.name);
  }

  @override
  void didChangeDependencies() {
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
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(
                    child: FormBuilderTextField(
                        name: widget.name,
                        focusNode: focusNode,
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
                        onChanged: (value) {})),
                const SizedBox(
                  width: kDefaultPadding / 2,
                ),
                OutlinedButton(
                    style: widget.buttonStyle,
                    onPressed: widget.onPressed,
                    child: Text(widget.buttonTitle))
              ])
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: FormBuilderTextField(
                              name: widget.name,
                              focusNode: focusNode,
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
                                  : widget.formKey.currentState!
                                          .fields[widget.name]!.isValid
                                      ? TextInputAction.done
                                      : TextInputAction.next,
                              validator: widget.validator,
                              decoration: widget.decoration,
                              onChanged: onChanged)),
                      const SizedBox(
                        width: kDefaultPadding / 2,
                      ),
                      OutlinedButton(
                          style: widget.buttonStyle,
                          onPressed: widget.onPressed,
                          child: Text(widget.buttonTitle))
                    ])
              ]);
  }
}
