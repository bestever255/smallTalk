import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/bloc/bloc/login/bloc/login_bloc.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/pages/signup.dart';

import '../constants.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;
  LoginForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEndables(LoginState state) {
    return isPopulated &&
        !state.isSubmitting &&
        state.isEmailValid &&
        state.isPasswordValid;
  }

  @override
  void initState() {
    // Access the blocProvider (Pass data from bloc provider to its inherited widget)
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  // Add the event to yield the state
  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // Bloc listener is a bloc builder but does not rebuild multiple times without change but rebuilds only once when state changes only so it good for ( Navigation , Showing Snack bars , Error dialogues)
    return BlocListener<LoginBloc, LoginState>(
      cubit: _loginBloc,
      listener: (context, state) {
        if (state.isFailure) {
          print('Failure');
          Scaffold.of(context)
            // ignore: deprecated_member_use
            ..hideCurrentSnackBar()
            // ignore: deprecated_member_use
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Login Failed!'),
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
                    Text('Loging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print('Success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        cubit: _loginBloc,
        builder: (context, LoginState state) {
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
                      onTap: isLoginButtonEndables(state)
                          ? _onFormSubmitted
                          : null,
                      child: Container(
                        width: width * .8,
                        height: height * .06,
                        decoration: BoxDecoration(
                            color: isLoginButtonEndables(state)
                                ? Colors.white
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(height * .05)),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: height * .025,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  GestureDetector(
                    child: Text(
                      'Are You New? Get an Account!',
                      style: TextStyle(
                        fontSize: height * .025,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return Signup(
                          userRepository: _userRepository,
                        );
                      }));
                    },
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
