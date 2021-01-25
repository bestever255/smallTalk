import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:tinder_clone/repository/search_repository.dart';
import 'package:tinder_clone/models/user.dart' as u;

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _searchRepository = GetIt.I.get<SearchRepository>();
  SearchBloc() : super(InitialSearchState());

  Future<void> getDifference(GeoPoint userLocation, int difference) async {
    try {
      // Get Your current Position
      Position position = await Geolocator.getCurrentPosition();
      // Get Other user location and calculate difference
      double location = Geolocator.distanceBetween(userLocation.latitude,
          userLocation.longitude, position.latitude, position.longitude);

      difference = location.toInt();
    } catch (e) {
      print(e);
    }
  }

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
