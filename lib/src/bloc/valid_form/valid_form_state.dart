import 'package:equatable/equatable.dart';

import '../../data/model/valid.dart';

abstract class ValidFormState extends Equatable {}

class ValidFormEmpty extends ValidFormState {
  @override
  List<Object?> get props => [];
}


class ValidFormUpdated extends ValidFormState {
  @override
  String toString() => 'ValidFormUpdated';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class ValidFormPass extends ValidFormState {
  @override
  String toString() => 'ValidFormPass';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ValidFormUnPass extends ValidFormState {
  @override
  String toString() => 'ValidFormUnPass';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ValidFormError extends ValidFormState {
  final String error;

  ValidFormError({required this.error});

  @override
  String toString() => 'ValidFormError { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
