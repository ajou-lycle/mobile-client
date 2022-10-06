import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SnackBarEvent extends Equatable {}

class ShowSnackBar extends SnackBarEvent {
  final List<Widget> children;

  ShowSnackBar({required this.children});

  @override
  String toString() => 'ShowSnackBar { children : $children }';

  @override
  List<Object?> get props => [];
}

class HideSnackBar extends SnackBarEvent {
  @override
  String toString() => 'HideSnackBar';

  @override
  List<Object?> get props => [];
}
