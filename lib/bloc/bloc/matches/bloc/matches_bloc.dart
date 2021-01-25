import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:tinder_clone/repository/matches_repository.dart';

part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  MatchesBloc() : super(LoadingState());
  final _matchesRepository = GetIt.I.get<MatchesRepository>();
  @override
  Stream<MatchesState> mapEventToState(
    MatchesEvent event,
  ) async* {
    if (event is LoadListEvent) {
      yield* _mapLoadListToState(currentUserId: event.userId);
    } else if (event is DeleteUserEvent) {
      yield* _mapDeleteUserToState(
          currentUser: event.currentUser, selectedUser: event.selectedUser);
    } else if (event is OpenChatEvent) {
      yield* _mapOpenChatToState(
          currentUser: event.currentUser, selectedUser: event.selectedUser);
    } else if (event is AcceptUserEvent) {
      yield* _mapAcceptedUserToState(
          currentUser: event.currentUser,
          selectedUser: event.selectedUser,
          selectedUserName: event.selectedUserName,
          selectedUserPhotoUrl: event.selectedUserPhotoUrl,
          currentUserName: event.currentUserName,
          currentUserPhotoUrl: event.currentUserPhotoUrl);
    }
  }

  Stream<MatchesState> _mapLoadListToState({String currentUserId}) async* {
    yield LoadingState();
    Stream<QuerySnapshot> matchesList =
        _matchesRepository.getMatchedList(currentUserId);
    Stream<QuerySnapshot> selectedList =
        _matchesRepository.getSelectedList(currentUserId);
    yield LoadUserState(matchedList: matchesList, selectedList: selectedList);
  }

  Stream<MatchesState> _mapDeleteUserToState(
      {String currentUser, String selectedUser}) async* {
    // yield* LoadingState();
    _matchesRepository.deleteUser(currentUser, selectedUser);
  }

  Stream<MatchesState> _mapOpenChatToState(
      {String currentUser, String selectedUser}) async* {
    // yield LoadingState();
    _matchesRepository.openChat(
        currentUserId: currentUser, selectedUserId: selectedUser);
  }

  Stream<MatchesState> _mapAcceptedUserToState({
    String currentUser,
    String selectedUser,
    String selectedUserName,
    String selectedUserPhotoUrl,
    String currentUserName,
    String currentUserPhotoUrl,
  }) async* {
    // yield LoadingState();
    await _matchesRepository.selectUser(
      currentUser,
      selectedUser,
      currentUserName,
      currentUserPhotoUrl,
      selectedUserName,
      selectedUserPhotoUrl,
    );
  }
}
