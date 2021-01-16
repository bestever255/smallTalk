import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/repository/messaging_repository.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository _messagingRepository;
  MessagingBloc({@required MessagingRepository messagingRepository})
      : assert(messagingRepository != null),
        _messagingRepository = messagingRepository,
        super(MessagingInitialState());

  void onFormSubmitted({
    TextEditingController textEditingController,
    String currentUserId,
    String selectedUserId,
    String currentUserName,
    MessagingBloc messagingBloc,
  }) {
    print('Message Submitted');
    messagingBloc.add(
      SendMessageEvent(
        message: Message(
          text: textEditingController.text.trim(),
          senderId: currentUserId,
          senderName: currentUserName,
          selectedUserId: selectedUserId,
          photos: null,
        ),
      ),
    );
    textEditingController.clear();
  }

  @override
  Stream<MessagingState> mapEventToState(
    MessagingEvent event,
  ) async* {
    if (event is MessagingStreamEvent) {
      yield* _mapMessagingStreamToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    } else if (event is SendMessageEvent) {
      yield* _mapSendMessageToState(message: event.message);
    } else if (event is DeleteMessageEvent) {
      yield* _mapDeleteMessageToState(
          messageId: event.messageId,
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    } else if (event is DeletePhotoEvent) {
      yield* _mapDeletePhotoToState(
          messageId: event.messageId,
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    }
  }

  Stream<MessagingState> _mapMessagingStreamToState(
      {String currentUserId, String selectedUserId}) async* {
    yield MessageLoadingState();

    Stream<QuerySnapshot> messageStream = _messagingRepository.getMessages(
        currentUserId: currentUserId, selectedUserId: selectedUserId);

    yield MessageLoadedState(messageStream: messageStream);
  }

  Stream<MessagingState> _mapSendMessageToState({Message message}) async* {
    await _messagingRepository.sendMessage(message: message);
  }

  Stream<MessagingState> _mapDeleteMessageToState(
      {String messageId, String currentUserId, String selectedUserId}) async* {
    yield MessageLoadingState();
    await _messagingRepository.deleteMessage(
        messageId: messageId,
        currentUserId: currentUserId,
        selectedUserId: selectedUserId);
  }

  Stream<MessagingState> _mapDeletePhotoToState(
      {String messageId, String currentUserId, String selectedUserId}) async* {
    yield MessageLoadingState();
    await _messagingRepository.deletePhoto(
        messageId: messageId,
        currentUserId: currentUserId,
        selectedUserId: selectedUserId);
  }
}
