import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/repository/messaging_repository.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository _messagingRepository;
  MessagingBloc({@required MessagingRepository messagingRepository})
      : assert(messagingRepository != null),
        _messagingRepository = messagingRepository;

  @override
  MessagingState get initialState => MessagingInitialState();

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
}
