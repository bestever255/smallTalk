part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

class ConnectionChangedEvent extends ConnectivityEvent {
  final ConnectionType connectionType;

  ConnectionChangedEvent(this.connectionType);

  @override
  List<Object> get props => [connectionType];
}
