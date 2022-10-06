import 'package:equatable/equatable.dart';

abstract class CertificationEvent extends Equatable {}

class Login extends CertificationEvent {
  Login();

  @override
  String toString() => 'Login';

  @override
  List<Object?> get props => [];
}

class Logout extends CertificationEvent {
  @override
  String toString() => 'Logout';

  @override
  List<Object?> get props => [];
}

class SignUp extends CertificationEvent {
  @override
  String toString() => 'SignUp';

  @override
  List<Object?> get props => [];
}

class PassCertification extends CertificationEvent {
  @override
  String toString() => 'PassCertification';

  @override
  List<Object?> get props => [];
}
