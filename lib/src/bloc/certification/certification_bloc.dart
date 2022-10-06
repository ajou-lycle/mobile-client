import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'certification_event.dart';
import 'certification_state.dart';

class CertificationBloc extends Bloc<CertificationEvent, CertificationState> {
  CertificationBloc() : super(CertificationEmpty()) {
    on<Login>(_mapLoginVisibleToState);
    on<Logout>(_mapLogoutToState);
    on<SignUp>(_mapSignUpToState);
    on<PassCertification>(_mapPassCertificationToState);
  }

  CertificationState get initialState => CertificationEmpty();

  Future<void> _mapLoginVisibleToState(
      CertificationEvent event, Emitter<CertificationState> emit) async {
    try {
      emit(CertificationLoaded());
    } catch (e) {
      emit(CertificationError(error: "login error"));
    }
  }

  Future<void> _mapLogoutToState(
      CertificationEvent event, Emitter<CertificationState> emit) async {
    try {
      emit(CertificationLoaded());
    } catch (e) {
      emit(CertificationError(error: "logout error"));
    }
  }

  Future<void> _mapSignUpToState(
      CertificationEvent event, Emitter<CertificationState> emit) async {
    try {
      emit(CertificationLoaded());
    } catch (e) {
      emit(CertificationError(error: "sign up error"));
    }
  }

  Future<void> _mapPassCertificationToState(
      CertificationEvent event, Emitter<CertificationState> emit) async {
    try {
      emit(CertificationLoaded());
    } catch (e) {
      emit(CertificationError(error: "pass certification error"));
    }
  }
}
