part of 'matches_bloc.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object> get props => [];
}

class LoadListEvent extends MatchesEvent {
  final String userId;
  LoadListEvent({this.userId});
  @override
  List<Object> get props => [userId];
}

class AcceptUserEvent extends MatchesEvent {
  final String currentUser;
  final String selectedUser;
  final String selectedUserName;
  final String selectedUserPhotoUrl;
  final String currentUserName;
  final String currentUserPhotoUrl;

  AcceptUserEvent({
    this.currentUser,
    this.selectedUser,
    this.selectedUserName,
    this.selectedUserPhotoUrl,
    this.currentUserName,
    this.currentUserPhotoUrl,
  });
  @override
  List<Object> get props => [
        currentUser,
        selectedUser,
        selectedUserName,
        selectedUserPhotoUrl,
        currentUserName,
        currentUserPhotoUrl
      ];
}

class DeleteUserEvent extends MatchesEvent {
  final String currentUser;
  final String selectedUser;

  DeleteUserEvent({this.currentUser, this.selectedUser});
  @override
  List<Object> get props => [currentUser, selectedUser];
}

class OpenChatEvent extends MatchesEvent {
  final String currentUser;
  final String selectedUser;

  OpenChatEvent({this.currentUser, this.selectedUser});
  @override
  List<Object> get props => [currentUser, selectedUser];
}
