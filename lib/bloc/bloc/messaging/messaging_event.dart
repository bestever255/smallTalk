part of 'messaging_bloc.dart';

abstract class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class MessagingStreamEvent extends MessagingEvent {
  final String currentUserId;
  final String selectedUserId;
  MessagingStreamEvent(
      {@required this.currentUserId, @required this.selectedUserId});
  @override
  List<Object> get props => [currentUserId, selectedUserId];
}

class SendMessageEvent extends MessagingEvent {
  final Message message;
  SendMessageEvent({@required this.message});
  @override
  List<Object> get props => [message];
}

class DeleteMessageEvent extends MessagingEvent {
  final String messageId;
  final String currentUserId;
  final String selectedUserId;

  DeleteMessageEvent(
      {@required this.messageId,
      @required this.currentUserId,
      @required this.selectedUserId});

  @override
  List<Object> get props => [messageId, currentUserId, selectedUserId];
}

class DeletePhotoEvent extends MessagingEvent {
  final String messageId;
  final String currentUserId;
  final String selectedUserId;

  DeletePhotoEvent(
      {@required this.messageId,
      @required this.currentUserId,
      @required this.selectedUserId});

  @override
  List<Object> get props => [messageId, currentUserId, selectedUserId];
}

class TypingMessageEvent extends MessagingEvent {}
