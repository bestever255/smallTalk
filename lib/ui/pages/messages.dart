import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tinder_clone/bloc/bloc/messages/messages_bloc.dart';
import 'package:tinder_clone/ui/widgets/chat_widget.dart';

class Messages extends StatefulWidget {
  final String userId;
  Messages({this.userId});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  MessagesBloc _messagesBloc;

  @override
  void initState() {
    super.initState();
    _messagesBloc = GetIt.I.get<MessagesBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      cubit: _messagesBloc,
      builder: (context, state) {
        if (state is MessagesInitial) {
          _messagesBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        } else if (state is ChatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;
          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('No Data');
              } else if (snapshot.data.docs.isNotEmpty) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      return ChatWidget(
                        creationTime: snapshot.data.docs[i].data()['timestamp'],
                        userId: widget.userId,
                        selectedUserId: snapshot.data.docs[i].id,
                      );
                    },
                  );
                }
              } else {
                return Center(
                  child: Text(
                    'You Don\'t have any Conversations yet',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              }
            },
          );
        }
        return Container();
      },
    );
  }
}
