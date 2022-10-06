import 'package:equatable/equatable.dart';

abstract class ValidFormEvent extends Equatable {}

class FormInputValidate extends ValidFormEvent {
  final int index;

  FormInputValidate({required this.index});

  @override
  String toString() => 'FormInputValidate { index : $index }';

  @override
  List<Object?> get props => [];
}

class FormInputUnValidate extends ValidFormEvent {
  final int index;

  FormInputUnValidate({required this.index});
  @override
  String toString() => 'FormInputUnValidate { index : $index }';

  @override
  List<Object?> get props => [];
}
