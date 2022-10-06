import 'package:equatable/equatable.dart';

abstract class ScrollFormWithKeyboardEvent extends Equatable {}

class KeyboardVisible extends ScrollFormWithKeyboardEvent {
  @override
  String toString() => 'KeyboardVisible';

  @override
  List<Object?> get props => [];
}

class KeyboardUnVisible extends ScrollFormWithKeyboardEvent {
  @override
  String toString() => 'KeyboardVisible';

  @override
  List<Object?> get props => [];
}
