import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

abstract class SnackBarState extends Equatable {}

class SnackBarEmpty extends SnackBarState {
  @override
  String toString() => 'SnackBarEmpty';

  @override
  List<Object?> get props => [];
}

class SnackBarShow extends SnackBarState {
  final List<Widget> children;
  final void Function()? closedCallback;

  SnackBarShow({required this.children, this.closedCallback});

  @override
  String toString() =>
      'SnackBarShow { children : $children, closedCallback : $closedCallback }';

  @override
  // TODO: implement props
  List<Object?> get props => [children, closedCallback];
}

class SnackBarUpdated extends SnackBarState {
  final List<Widget> children;

  SnackBarUpdated({required this.children});

  @override
  String toString() => 'SnackBarShow { children : $children }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SnackBarError extends SnackBarState {
  final String error;

  SnackBarError({required this.error});

  @override
  String toString() => 'SnackBarError { error : $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
