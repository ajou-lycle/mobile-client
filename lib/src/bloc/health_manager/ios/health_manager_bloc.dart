import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/health/ios_health_repository.dart';
import 'health_manager_event.dart';
import 'health_manager_state.dart';

class IOSHealthManagerBloc
    extends Bloc<IOSHealthManagerEvent, IOSHealthManagerState> {
  final IOSHealthRepository iosHealthRepository = IOSHealthRepository();

  IOSHealthManagerBloc() : super(IOSHealthManagerEmpty()) {
    on<IOSEmptyHealthManager>(_mapEmptyHealthAuthorityToState);
    on<IOSCreateHealthManager>(_mapCreateHealthAuthorityState);
    on<IOSDeleteHealthManager>(_mapDeleteHealthAuthorityState);
    on<IOSErrorHealthManager>(_mapErrorHealthAuthorityToState);
  }

  IOSHealthManagerState get initialState => IOSHealthManagerEmpty();

  Future<void> _mapEmptyHealthAuthorityToState(
      IOSEmptyHealthManager event, Emitter<IOSHealthManagerState> emit) async {
    emit(IOSHealthManagerEmpty());
  }

  Future<void> _mapCreateHealthAuthorityState(
      IOSCreateHealthManager event, Emitter<IOSHealthManagerState> emit) async {
    try {
      emit(IOSHealthManagerUpdated());
      emit(IOSHealthManagerLoaded());
    } catch (e) {
      emit(IOSHealthManagerError(error: "HealthAuthority create error"));
    }
  }

  Future<void> _mapDeleteHealthAuthorityState(
      IOSDeleteHealthManager event, Emitter<IOSHealthManagerState> emit) async {
    try {
      emit(IOSHealthManagerUpdated());
      emit(IOSHealthManagerLoaded());
    } catch (e) {
      emit(IOSHealthManagerError(error: "HealthAuthority delete error"));
    }
  }

  Future<void> _mapErrorHealthAuthorityToState(
      IOSErrorHealthManager event, Emitter<IOSHealthManagerState> emit) async {
    emit(IOSHealthManagerError(error: "HealthAuthority error"));
  }
}
