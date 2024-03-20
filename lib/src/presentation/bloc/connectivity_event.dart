import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityResult connectivity;

  const ConnectivityChanged(this.connectivity);

  @override
  List<Object> get props => [connectivity];
}

class ForceConnectivityCheckEvent extends ConnectivityEvent {}

class ApiConnectivityChangedEvent extends ConnectivityEvent {
  final bool isApiAvailable;

  const ApiConnectivityChangedEvent(this.isApiAvailable);

  @override
  List<Object> get props => [isApiAvailable];
}
