part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String userId;
  Authenticated(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => "Authenticated $userId";
}

class AuthenticatedButNotSet extends AuthenticationState {
  final String userId;
  AuthenticatedButNotSet(this.userId);

  @override
  List<Object> get props => [userId];
}

class Unauthenticated extends AuthenticationState {}

class UserOnline extends AuthenticationState {
  final String userId;
  UserOnline({this.userId});
  @override
  List<Object> get props => [userId];
}

class UserOffline extends AuthenticationState {
  final String userId;
  UserOffline({this.userId});
  @override
  List<Object> get props => [userId];
}
