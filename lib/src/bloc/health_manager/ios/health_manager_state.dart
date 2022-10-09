import 'package:equatable/equatable.dart';

abstract class IOSHealthManagerState extends Equatable {}

class IOSHealthManagerEmpty extends IOSHealthManagerState {
  @override
  List<Object?> get props => [];
}

class IOSHealthManagerLoading extends IOSHealthManagerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class IOSHealthManagerLoaded extends IOSHealthManagerState {
  @override
  String toString() => 'IOSHealthManagerLoaded';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class IOSHealthManagerUpdated extends IOSHealthManagerState {
  @override
  String toString() => 'IOSHealthManagerUpdated';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class IOSHealthManagerError extends IOSHealthManagerState {
  final String error;

  IOSHealthManagerError({required this.error});

  @override
  String toString() => 'IOSHealthManagerError { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
