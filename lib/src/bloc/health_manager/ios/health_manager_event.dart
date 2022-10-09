import 'package:equatable/equatable.dart';

abstract class IOSHealthManagerEvent extends Equatable {}

class IOSEmptyHealthManager extends IOSHealthManagerEvent {
  @override
  List<Object?> get props => [];
}

class IOSCreateHealthManager extends IOSHealthManagerEvent {
  final List readTypes;
  final List writeTypes;

  IOSCreateHealthManager({required this.readTypes, required this.writeTypes});

  @override
  String toString() =>
      'IOSCreateHealthManager { readType: $readTypes, writeTypes: $writeTypes }';

  @override
  // TODO: implement props
  List<Object?> get props => [readTypes, writeTypes];
}

class IOSDeleteHealthManager extends IOSHealthManagerEvent {
  final int index;

  IOSDeleteHealthManager({required this.index});

  @override
  String toString() => 'IOSDeleteHealthManager { index: $index }';

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

class IOSErrorHealthManager extends IOSHealthManagerEvent {
  final String error;

  IOSErrorHealthManager({required this.error});

  @override
  String toString() => 'IOSErrorHealthManager { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
