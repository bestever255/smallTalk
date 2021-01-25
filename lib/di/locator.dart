import 'package:get_it/get_it.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/bloc/bloc/login/bloc/login_bloc.dart';
import 'package:tinder_clone/bloc/bloc/matches/bloc/matches_bloc.dart';
import 'package:tinder_clone/bloc/bloc/messages/messages_bloc.dart';
import 'package:tinder_clone/bloc/bloc/messaging/messaging_bloc.dart';
import 'package:tinder_clone/bloc/bloc/profile/bloc/profile_bloc.dart';
import 'package:tinder_clone/bloc/bloc/search/bloc/search_bloc.dart';
import 'package:tinder_clone/bloc/bloc/signup/bloc/signup_bloc.dart';
import 'package:tinder_clone/repository/matches_repository.dart';
import 'package:tinder_clone/repository/message_repository.dart';
import 'package:tinder_clone/repository/messaging_repository.dart';
import 'package:tinder_clone/repository/search_repository.dart';
import 'package:tinder_clone/repository/user_repository.dart';

final locator = GetIt.I;
void setup() {
  locator.registerLazySingleton<AuthenticationBloc>(() => AuthenticationBloc());
  locator.registerLazySingleton<LoginBloc>(() => LoginBloc());
  locator.registerLazySingleton<MatchesBloc>(() => MatchesBloc());
  locator.registerLazySingleton<MessagesBloc>(() => MessagesBloc());
  locator.registerLazySingleton<MessagingBloc>(() => MessagingBloc());
  locator.registerLazySingleton<ProfileBloc>(() => ProfileBloc());
  locator.registerLazySingleton<SearchBloc>(() => SearchBloc());
  locator.registerLazySingleton<SignupBloc>(() => SignupBloc());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<MatchesRepository>(() => MatchesRepository());
  locator.registerLazySingleton<MessageRepository>(() => MessageRepository());
  locator
      .registerLazySingleton<MessagingRepository>(() => MessagingRepository());
  locator.registerLazySingleton<SearchRepository>(() => SearchRepository());
}
