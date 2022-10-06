import 'package:equatable/equatable.dart';

abstract class ScrollFormWithKeyboardState extends Equatable {}

class ScrollFormWithKeyboardEmpty extends ScrollFormWithKeyboardState {
  @override
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardUpdated extends ScrollFormWithKeyboardState {
  @override
  String toString() =>
      'ScrollFormWithKeyboardUpdatedState';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardVisible extends ScrollFormWithKeyboardState {
  @override
  String toString() =>
      'ScrollFormWithKeyboardVisibleState';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardUnVisible extends ScrollFormWithKeyboardState {
  @override
  String toString() => 'ScrollFormWithKeyboardUnVisibleState';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardError extends ScrollFormWithKeyboardState {
  final String error;

  ScrollFormWithKeyboardError({required this.error});

  @override
  String toString() => 'ScrollFormWithKeyboardErrorState { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
