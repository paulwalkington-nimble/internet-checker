import 'dart:async';

import 'package:internet_checker/src/presentation/bloc/connectivity_bloc.dart';
import 'package:internet_checker/src/presentation/bloc/connectivity_event.dart';

class ApiTimer {
  final ConnectivityBloc connectivityBloc;

  ApiTimer(this.connectivityBloc);

  void start() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      connectivityBloc.add(const ApiConnectivityChangedEvent(false));
    });
  }
}
