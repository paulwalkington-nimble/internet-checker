import 'dart:async';

import 'package:bloc/bloc.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc() : super(ConnectivityUnknown()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      add(ConnectivityChanged(result));
    });
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ForceConnectivityCheckEvent>(_checkConnectivityStatus);
  }

  void _onConnectivityChanged(ConnectivityChanged event, emit) async {
    final connectivity = event.connectivity;
    if (connectivity == ConnectivityResult.none) {
      emit(ConnectivityNone());
    } else if (connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.mobile) {
      emit(ConnectivityAvaliable());
    } else {
      emit(ConnectivityNone());
    }
  }

  void _checkConnectivityStatus(ForceConnectivityCheckEvent event, emit) async {
    var connectivity = await (Connectivity().checkConnectivity());

    if (connectivity == ConnectivityResult.none) {
      emit(ConnectivityNone());
    } else if (connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.mobile) {
      emit(ConnectivityAvaliable());
    } else {
      emit(ConnectivityNone());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
