import 'package:equatable/equatable.dart';

abstract class ScrollFormWithKeyboardEvent extends Equatable {}

class KeyboardVisible extends ScrollFormWithKeyboardEvent {
  final double scrollHeight;

  KeyboardVisible({required this.scrollHeight});

  @override
  String toString() => 'KeyboardVisible { scrollHeight: $scrollHeight }';

  @override
  List<Object?> get props => [scrollHeight];
}

class KeyboardUnVisible extends ScrollFormWithKeyboardEvent {
  @override
  String toString() => 'KeyboardVisible';

  @override
  List<Object?> get props => [];
}
