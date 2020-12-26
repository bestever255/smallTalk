part of 'messages_bloc.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class ChatStreamEvent extends MessagesEvent {
  final String currentUserId;
  ChatStreamEvent({this.currentUserId});
  @override
  List<Object> get props => [currentUserId];
}
