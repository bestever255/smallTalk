part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}

class ChatLoadingState extends MessagesState {}

class ChatLoadedState extends MessagesState {
  final Stream<QuerySnapshot> chatStream;
  ChatLoadedState({this.chatStream});
  @override
  List<Object> get props => [chatStream];
}
