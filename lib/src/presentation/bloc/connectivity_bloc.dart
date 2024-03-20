import 'dart:async';

import 'package:bloc/bloc.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityState lastConnectivityStatus = ConnectivityUnknown();

  bool isApiAvailable = true;
  ConnectivityResult currentPhoneConnectivityStatus = ConnectivityResult.other;

  ConnectivityBloc() : super(ConnectivityUnknown()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      add(ConnectivityChanged(result));
    });
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ForceConnectivityCheckEvent>(_checkConnectivityStatus);
    on<ApiConnectivityChangedEvent>(_checkApiConnectivityStatus);
  }

  void _onConnectivityChanged(ConnectivityChanged event, emit) async {
    currentPhoneConnectivityStatus = event.connectivity;
    emitConnectionStatus(emit);
  }

  void _checkConnectivityStatus(ForceConnectivityCheckEvent event, emit) async {
    currentPhoneConnectivityStatus = await (Connectivity().checkConnectivity());
    emitConnectionStatus(emit);
  }

  void _checkApiConnectivityStatus(
      ApiConnectivityChangedEvent event, emit) async {
    isApiAvailable = event.isApiAvailable;
    emitConnectionStatus(emit);
  }

  void emitConnectionStatus(emit) {
    ConnectivityState currentConnectivityStatus;

    print('isApiAvailable: $isApiAvailable');
    print('currentPhoneConnectivityStatus: $currentPhoneConnectivityStatus');

    if ((currentPhoneConnectivityStatus == ConnectivityResult.wifi ||
            currentPhoneConnectivityStatus == ConnectivityResult.mobile) &&
        isApiAvailable == true) {
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

    print('currentConnectivityStatus: $currentConnectivityStatus');

    // if (connectivity == ConnectivityResult.wifi ||
    //     connectivity == ConnectivityResult.mobile) {
    //   if (lastConnectivityStatus == ConnectivityNone()) {
    //     currentConnectivityStatus = ConnectivityRestored();
    //   } else {
    //     currentConnectivityStatus = ConnectivityAvaliable();
    //   }
    // } else {
    //   currentConnectivityStatus = ConnectivityNone();
    // }

    // emit(currentConnectivityStatus);
    // lastConnectivityStatus = currentConnectivityStatus;
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
