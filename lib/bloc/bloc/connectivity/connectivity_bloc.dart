import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/ui/constants.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity connectivity;
  ConnectivityBloc({@required this.connectivity})
      : super(ConnectivityInitial()) {
    monitorInternetConnection();
  }
  void monitorInternetConnection() {
    connectivity.onConnectivityChanged.listen((connectionResult) {
      if (connectionResult == ConnectivityResult.wifi) {
        this.add(ConnectionChangedEvent(ConnectionType.Wifi));
      } else if (connectionResult == ConnectivityResult.mobile) {
        this.add(ConnectionChangedEvent(ConnectionType.Mobile));
      } else if (connectionResult == ConnectivityResult.none) {
        this.add(ConnectionChangedEvent(ConnectionType.Disconnected));
      }
    });
  }

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is ConnectionChangedEvent) {
      switch (event.connectionType) {
        case ConnectionType.Wifi:
          {
            yield InternetConnected(connectionType: ConnectionType.Wifi);
            break;
          }
        case ConnectionType.Mobile:
          {
            yield InternetConnected(connectionType: ConnectionType.Mobile);
            break;
          }
        case ConnectionType.Disconnected:
          {
            yield InternetDisconnected();
            break;
          }
      }
    }
  }
}
