import 'package:equatable/equatable.dart';

abstract class CertificationState extends Equatable {}

class CertificationEmpty extends CertificationState {
  @override
  List<Object?> get props => [];
}

class CertificationUpdated extends CertificationState {
  CertificationUpdated();

  @override
  String toString() => 'CertificationUpdated';

  @override
// TODO: implement props
  List<Object?> get props => [];
}

class CertificationLoaded extends CertificationState {
  @override
  String toString() => 'CertificationUploaded';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CertificationPass extends CertificationState {
  CertificationPass();

  @override
  String toString() => 'CertificationPass';

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CertificationError extends CertificationState {
  final String error;

  CertificationError({required this.error});

  @override
  String toString() => 'CertificationError { error: $error }';

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
