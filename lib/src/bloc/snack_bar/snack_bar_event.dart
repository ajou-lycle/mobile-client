import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SnackBarEvent extends Equatable {}

class ShowSnackBar extends SnackBarEvent {
  final List<Widget> children;
  final void Function()? closedCallback;

  ShowSnackBar({required this.children, this.closedCallback});

  @override
  String toString() =>
      'ShowSnackBar { children : $children, closedCallback $closedCallback }';

  @override
  List<Object?> get props => [children, closedCallback];
}

class HideSnackBar extends SnackBarEvent {
  @override
  String toString() => 'HideSnackBar';

  @override
  List<Object?> get props => [];
}
