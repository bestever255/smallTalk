import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/repository/message_repository.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessageRepository _messageRepository;
  MessagesBloc({@required MessageRepository messageRepository})
      : assert(messageRepository != null),
        _messageRepository = messageRepository;

  @override
  MessagesState get initialState => MessagesInitial();
  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (event is ChatStreamEvent) {
      yield* _mapChatStreamToState(currentUserId: event.currentUserId);
    }
  }

  Stream<MessagesState> _mapChatStreamToState({String currentUserId}) async* {
    yield ChatLoadingState();

    Stream<QuerySnapshot> chatStream =
        _messageRepository.getChats(userId: currentUserId);
    // Pass State so we can use it in main method
    yield ChatLoadedState(chatStream: chatStream);
  }
}
