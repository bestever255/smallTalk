part of 'authentication_bloc.dart';

// interacts with the ui
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class UserClosedApp extends AuthenticationEvent {
  final String userId;
  UserClosedApp({this.userId});
  @override
  List<Object> get props => [userId];
}

class UserOpenedApp extends AuthenticationEvent {
  final String userId;
  UserOpenedApp({this.userId});
  @override
  List<Object> get props => [userId];
}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
