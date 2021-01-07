import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/messaging/messaging_bloc.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/messaging_repository.dart';
import 'package:tinder_clone/ui/widgets/message_page_widgets/message_page_textform.dart';

import 'message_widget.dart';

//1- add intl package and fix date
//2- add seen feature
//3- cache messages
//4- fix laggy list view
class MessagePageListView extends StatefulWidget {
  final User currentUser;
  final User selectedUser;
  MessagePageListView(
      {@required this.currentUser, @required this.selectedUser});
  @override
  _MessagePageListViewState createState() => _MessagePageListViewState();
}

class _MessagePageListViewState extends State<MessagePageListView> {
  MessagingBloc _messagingBloc;
  MessagingRepository _messagingRepository;

  @override
  void initState() {
    super.initState();
    _messagingRepository = MessagingRepository();
    _messagingBloc = MessagingBloc(messagingRepository: _messagingRepository);
  }

  @override
  void dispose() {
    _messagingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
      cubit: _messagingBloc,
      builder: (context, state) {
        if (state is MessagingInitialState) {
          _messagingBloc.add(
            MessagingStreamEvent(
                currentUserId: widget.currentUser.uid,
                selectedUserId: widget.selectedUser.uid),
          );
        } else if (state is MessageLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MessageLoadedState) {
          // Handle the messaging page
          Stream<QuerySnapshot> messageStream = state.messageStream;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: messageStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'Start The Conversation?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else if (snapshot.data.docs.isNotEmpty) {
                    return Flexible(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, i) {
                          return MessageWidget(
                            selectedUserId: widget.selectedUser.uid,
                            currentUserId: widget.currentUser.uid,
                            messageId: snapshot.data.docs[i].id,
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Start The Conversation ?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                },
              ),
              MessagePageTextForm(
                currentUser: widget.currentUser,
                selectedUser: widget.selectedUser,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
