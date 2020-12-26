part of 'signup_bloc.dart';

@immutable
class SignupState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  SignupState(
      {@required this.isEmailValid,
      @required this.isPasswordValid,
      @required this.isSubmitting,
      @required this.isFailure,
      @required this.isSuccess});

  // factory is a constructor that does not have an instance
  // this is the initial state of the form
  factory SignupState.empty() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }
  // When pressed login and loading
  factory SignupState.loading() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isFailure: false,
      isSuccess: false,
    );
  }
  // When failure
  factory SignupState.failure() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isFailure: true,
      isSuccess: false,
    );
  }
  // When it is success
  factory SignupState.success() {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: true,
    );
  }
  // When Writing email and password
  SignupState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
    );
  }

  SignupState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitEnabled,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure}) {
    return SignupState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
