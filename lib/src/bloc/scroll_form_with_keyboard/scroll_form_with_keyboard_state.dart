import 'package:equatable/equatable.dart';

abstract class ScrollFormWithKeyboardState extends Equatable {}

class ScrollFormWithKeyboardEmpty extends ScrollFormWithKeyboardState {
  @override
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardErrorTextExist extends ScrollFormWithKeyboardState {
  final double scrollHeight;

  ScrollFormWithKeyboardErrorTextExist({required this.scrollHeight});

  @override
  String toString() =>
      'ScrollFormWithKeyboardErrorTextExist { scrollHeight: $scrollHeight }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardUpdated extends ScrollFormWithKeyboardState {
  final double scrollHeight;

  ScrollFormWithKeyboardUpdated({required this.scrollHeight});

  @override
  String toString() =>
      'ScrollFormWithKeyboardUpdatedState { scrollHeight: $scrollHeight }';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScrollFormWithKeyboardVisible extends ScrollFormWithKeyboardState {
  final double scrollHeight;

  ScrollFormWithKeyboardVisible({required this.scrollHeight});

  @override
  String toString() =>
      'ScrollFormWithKeyboardVisibleState { scrollHeight: $scrollHeight }';

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
