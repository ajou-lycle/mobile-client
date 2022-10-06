import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../bloc/valid_form/valid_form_bloc.dart';
import '../../../constants/ui.dart';

class ValidFormBuilderTextField extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final int index;
  final String name;
  final InputDecoration decoration;
  final String? title;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? outerSuffix;
  bool obscureText;

  ValidFormBuilderTextField(
      {Key? key,
      required this.formKey,
      required this.index,
      required this.name,
      required this.decoration,
      this.title,
      this.focusNode,
      this.validator,
      this.suffixIcon,
      this.obscureText = false,
      this.outerSuffix})
      : super(key: key);

  @override
  State<ValidFormBuilderTextField> createState() =>
      ValidFormBuilderTextFieldState();
}

class ValidFormBuilderTextFieldState extends State<ValidFormBuilderTextField> {
  late ValidFormBloc _validFormBloc;
  bool _isValid = false;
  bool? _isLast = false;

  _validate() {
    if (widget.formKey.currentState == null) {
      return;
    }
    bool? isValid =
        widget.formKey.currentState?.fields[widget.name]?.validate();

    if (isValid == null) {
      return;
    }

    setState(() => _isValid = isValid);
    _validFormBloc.mapInputToEvent(_isValid, widget.index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _validFormBloc = BlocProvider.of<ValidFormBloc>(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (widget.formKey.currentState == null) {
      return;
    }
    if (widget.formKey.currentState?.fields == null) {
      return;
    }

    setState(() =>
        _isLast = widget.formKey.currentState?.fields.containsKey(widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return widget.title == null
        ? widget.outerSuffix == null
            ? FormBuilderTextField(
                focusNode: widget.focusNode,
                name: widget.name,
                obscureText: widget.obscureText,
                cursorColor: Colors.black,
                cursorWidth: 1,
                textInputAction: _isLast == null
                    ? TextInputAction.next
                    : _isLast!
                        ? TextInputAction.done
                        : TextInputAction.next,
                onChanged: (value) => _validate(),
                onEditingComplete: () {
                  _validate();

                  if (_isValid) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                decoration: widget.decoration,
                validator: widget.validator)
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: FormBuilderTextField(
                          focusNode: widget.focusNode,
                          name: widget.name,
                          obscureText: widget.obscureText,
                          cursorColor: Colors.black,
                          cursorWidth: 1,
                          textInputAction: _isLast == null
                              ? TextInputAction.next
                              : _isLast!
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                          onChanged: (value) => _validate(),
                          onEditingComplete: () {
                            _validate();

                            if (_isValid) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          decoration: widget.decoration,
                          validator: widget.validator)),
                  const SizedBox(
                    width: kHalfPadding,
                  ),
                  widget.outerSuffix!
                ],
              )
        : widget.outerSuffix == null
            ? Column(
                mainAxisSize: MainAxisSize.min,
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
                        focusNode: widget.focusNode,
                        name: widget.name,
                        obscureText: widget.obscureText,
                        cursorColor: Colors.black,
                        cursorWidth: 1,
                        textInputAction: _isLast == null
                            ? TextInputAction.next
                            : _isLast!
                                ? TextInputAction.done
                                : TextInputAction.next,
                        onChanged: (value) => _validate(),
                        onEditingComplete: () {
                          _validate();

                          if (_isValid) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        decoration: widget.decoration,
                        validator: widget.validator)
                  ])
            : Column(
                mainAxisSize: MainAxisSize.min,
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
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: FormBuilderTextField(
                                  focusNode: widget.focusNode,
                                  name: widget.name,
                                  obscureText: widget.obscureText,
                                  cursorColor: Colors.black,
                                  cursorWidth: 1,
                                  textInputAction: _isLast == null
                                      ? TextInputAction.next
                                      : _isLast!
                                          ? TextInputAction.done
                                          : TextInputAction.next,
                                  onChanged: (value) => _validate(),
                                  onEditingComplete: () {
                                    _validate();

                                    if (_isValid) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                  decoration: widget.decoration,
                                  validator: widget.validator)),
                          const SizedBox(
                            width: kHalfPadding,
                          ),
                          widget.outerSuffix!
                        ])
                  ]);
  }
}
