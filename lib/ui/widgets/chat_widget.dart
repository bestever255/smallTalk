import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tinder_clone/bloc/bloc/messages/messages_bloc.dart';
import 'package:tinder_clone/models/chat.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/models/user.dart' as u;
import 'package:tinder_clone/repository/message_repository.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

// ignore: must_be_immutable
class ChatWidget extends StatefulWidget {
  final String userId;
  final String selectedUserId;
  final Timestamp creationTime;

  ChatWidget({this.userId, this.selectedUserId, this.creationTime});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  MessageRepository _messageRepository = MessageRepository();
  ChatModel _chat;
  u.User _user;
  MessagesBloc _messageBloc;

  Future<ChatModel> getUserDetails() async {
    _user =
        await _messageRepository.getUserDetail(userId: widget.selectedUserId);
    Message message = await _messageRepository
        .getLastMessage(
            currentUserId: widget.userId, selectedUserId: widget.selectedUserId)
        .catchError((e) => print(e));
    if (message == null) {
      _chat = ChatModel(
          name: _user.name,
          photourl: _user.photo,
          lastMessageSend: null,
          lastMessagePhoto: null,
          timestamp: null);
    } else {
      _chat = ChatModel(
          name: _user.name,
          photourl: _user.photo,
          lastMessageSend: message.text,
          lastMessagePhoto: message.photos == null ? null : message.photos,
          timestamp: message.timestamp);
    }
    return _chat;
  }

  @override
  void initState() {
    super.initState();
    _messageBloc = MessagesBloc(messageRepository: _messageRepository);
  }

  @override
  void dispose() {
    _messageBloc.close();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getUserDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GestureDetector(
            onTap: () async {
              await _messageBloc.openChat(
                context: context,
                selectedUserId: widget.selectedUserId,
                userId: widget.userId,
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Wrap(
                      children: [
                        Text(
                          'Do you want to delete this chat ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * .02),
                        Text(
                          'You will not be able to recover this chat',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          await _messageRepository.deleteChat(
                            currentUserId: widget.userId,
                            selectedUserId: widget.selectedUserId,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.all(height * .015),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    height * .02,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            height: height * .07,
                            width: height * .07,
                            child: PhotoWidget(_user.photo),
                          ),
                        ),
                        SizedBox(
                          width: width * .03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user.name,
                              style: TextStyle(
                                fontSize: height * .03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: height * .002,
                            ),
                            _chat.lastMessageSend != null
                                ? Text(
                                    _chat.lastMessageSend,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                : _chat.lastMessagePhoto == null
                                    ? Text('Chat Room Available')
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            color: Colors.grey,
                                            size: height * .02,
                                          ),
                                          Text(
                                            'Photo',
                                            style: TextStyle(
                                              fontSize: height * .015,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                          ],
                        ),
                      ],
                    ),
                    _chat.timestamp != null
                        ? Text(
                            timeago.format(_chat.timestamp.toDate()),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            timeago.format(widget.creationTime.toDate()),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
