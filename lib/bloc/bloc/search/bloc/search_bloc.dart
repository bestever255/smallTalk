import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/repository/search_repository.dart';
import 'package:tinder_clone/models/user.dart' as u;

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository _searchRepository;
  SearchBloc({@required SearchRepository searchRepository})
      : assert(searchRepository != null),
        _searchRepository = searchRepository;

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId,
          name: event.name,
          photourl: event.photourl);
    } else if (event is PassUserEvent) {
      yield* _mapPassToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    } else if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(currentUserId: event.userId);
    }
  }

  Stream<SearchState> _mapSelectToState(
      {String currentUserId,
      String selectedUserId,
      String name,
      String photourl}) async* {
    yield LoadingState();
    u.User user;
    user = await _searchRepository.chooseUser(
        currentUserId, selectedUserId, name, photourl);
    u.User currentUser =
        await _searchRepository.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapPassToState(
      {String currentUserId, String selectedUserId}) async* {
    yield LoadingState();
    u.User user =
        await _searchRepository.passUser(currentUserId, selectedUserId);
    u.User currentUser =
        await _searchRepository.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapLoadUserToState({String currentUserId}) async* {
    yield LoadingState();

    u.User user = await _searchRepository.getUser(currentUserId);
    u.User currentUser =
        await _searchRepository.getUserInterests(currentUserId);
    yield LoadUserState(user, currentUser);
  }
}
