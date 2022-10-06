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

  SnackBarShow({required this.children});

  @override
  String toString() => 'SnackBarShow { children : $children }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
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
