import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/bloc/bloc/signup/bloc/signup_bloc.dart';
import 'package:tinder_clone/ui/constants.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignupBloc _signupBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignedUpButtonEndables(SignupState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    // This is more favortied
    // _signupBloc = BlocProvider.of<SignupBloc>(context);
    //or
    _signupBloc = SignupBloc();

    // Make Listeners to controller so when typing we can get notified
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onEmailChanged() {
    // Pass an event
    _signupBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signupBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _signupBloc.add(SignUpWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signupBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // Listen to changes in state
    return BlocListener(
      cubit: _signupBloc,
      listener: (BuildContext context, SignupState state) {
        if (state.isFailure) {
          print('Failure');
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sign Up Failed!'),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print('Submitting');
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Signing Up...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print('Success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        cubit: _signupBloc,
        builder: (context, SignupState state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: kBackGroundColor,
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Chill',
                      style: TextStyle(
                        fontSize: width * .2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: width * .8,
                    child: Divider(
                      height: height * .05,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(height * 0.02),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        // If email is invalid we save not valid
                        return !state.isEmailValid ? 'Invalid Email' : null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: height * .03,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(height * 0.02),
                    child: TextFormField(
                      controller: _passwordController,
                      autocorrect: false,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        // If email is invalid we save not valid
                        return !state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: height * .03,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(height * .02),
                    child: GestureDetector(
                      onTap: isSignedUpButtonEndables(state)
                          ? _onFormSubmitted
                          : null,
                      child: Container(
                        width: width * .8,
                        height: height * .06,
                        decoration: BoxDecoration(
                            color: isSignedUpButtonEndables(state)
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(height * .05)),
                        child: Center(
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: height * .025,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
