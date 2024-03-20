import 'dart:async';

import 'package:bloc/bloc.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityState lastConnectivityStatus = ConnectivityUnknown();

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
    emitConnectionStatus(connectivity, emit);
  }

  void _checkConnectivityStatus(ForceConnectivityCheckEvent event, emit) async {
    var connectivity = await (Connectivity().checkConnectivity());
    emitConnectionStatus(connectivity, emit);
  }

  void emitConnectionStatus(ConnectivityResult connectivity, emit) {
    ConnectivityState currentConnectivityStatus;

    if (connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.mobile) {
      if (lastConnectivityStatus == ConnectivityNone()) {
        currentConnectivityStatus = ConnectivityRestored();
      } else {
        currentConnectivityStatus = ConnectivityAvaliable();
      }
    } else {
      currentConnectivityStatus = ConnectivityNone();
    }

    emit(currentConnectivityStatus);
    lastConnectivityStatus = currentConnectivityStatus;
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
