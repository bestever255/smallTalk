part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class InternetConnected extends ConnectivityState {
  final ConnectionType connectionType;

  InternetConnected({@required this.connectionType});
  @override
  List<Object> get props => [connectionType];
}

class InternetDisconnected extends ConnectivityState {}
