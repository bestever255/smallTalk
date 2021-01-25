import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/message_repository.dart';
import 'package:tinder_clone/ui/pages/messaging_page.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final _messageRepository = GetIt.I.get<MessageRepository>();
  MessagesBloc() : super(MessagesInitial());

  Future deleteChat({String userId, String selectedUserId}) async {
    await _messageRepository.deleteChat(
      currentUserId: userId,
      selectedUserId: selectedUserId,
    );
  }

  Future openChat(
      {BuildContext context, String userId, String selectedUserId}) async {
    User currentUser = await _messageRepository.getUserDetail(userId: userId);
    User selectedUser =
        await _messageRepository.getUserDetail(userId: selectedUserId);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MessagingPage(
          currentUser,
          selectedUser,
        ),
      ),
    );
  }

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
