part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// When Typing the email
class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Email Changed $email';
}

// When Typing the password
class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'Email Changed $password';
}

class Submitted extends LoginEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}

// When pressing the submit button
class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;
  LoginWithCredentialsPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
