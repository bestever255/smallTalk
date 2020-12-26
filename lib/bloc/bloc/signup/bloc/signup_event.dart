part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignupEvent {
  final String email;
  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Email Changed $email';
}

class PasswordChanged extends SignupEvent {
  final String password;
  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'Password Changed $password';
}

class SignUpWithCredentialsPressed extends SignupEvent {
  final String email;
  final String password;
  SignUpWithCredentialsPressed({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
