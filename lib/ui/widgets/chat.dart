import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/chat.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/models/user.dart' as u;
import 'package:tinder_clone/repository/message_repository.dart';
import 'package:tinder_clone/ui/pages/messaging_page.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

class Chat extends StatefulWidget {
  final String userId;
  final String selectedUserId;
  final Timestamp creationTime;

  const Chat({this.userId, this.selectedUserId, this.creationTime});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  MessageRepository _messageRepository = MessageRepository();
  ChatModel _chat;
  u.User _user;

  Future<ChatModel> getUserDetails() async {
    _user =
        await _messageRepository.getUserDetail(userId: widget.selectedUserId);
    Message message = await _messageRepository
        .getLastMessage(
            currentUserId: widget.userId, selectedUserId: widget.selectedUserId)
        .catchError((e) => print(e));

    if (message == null) {
      return ChatModel(
          name: _user.name,
          photourl: _user.photo,
          lastMessageSend: null,
          lastMessagePhoto: null,
          timestamp: null);
    } else {
      return ChatModel(
          name: _user.name,
          photourl: _user.photo,
          lastMessageSend: message.text,
          lastMessagePhoto: message.photos,
          timestamp: message.timestamp);
    }
  }

  Future openChat() async {
    u.User currentUser =
        await _messageRepository.getUserDetail(userId: widget.userId);
    u.User selectedUser =
        await _messageRepository.getUserDetail(userId: widget.selectedUserId);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MessagingPage(
          currentUser,
          selectedUser,
        ),
      ),
    );
  }

  Future deleteChat() async {
    await _messageRepository.deleteChat(
      currentUserId: widget.userId,
      selectedUserId: widget.selectedUserId,
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getUserDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Nothing is here',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () async {
              await openChat();
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
                        Text(
                          'You will not be able to recover this chat',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
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
                          await deleteChat();
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
              padding: EdgeInsets.all(height * .02),
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
                              height: height * .06,
                              width: width * .06,
                              child: PhotoWidget(_user.photo)),
                        ),
                        SizedBox(
                          width: width * .02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user.name,
                              style: TextStyle(
                                fontSize: height * .05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _chat.lastMessageSend != null
                                ? Text(
                                    _chat.lastMessageSend,
                                    overflow: TextOverflow.fade,
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
                            _chat.timestamp.toDate().hour.toString() +
                                ":" +
                                _chat.timestamp.toDate().minute.toString(),
                            style: TextStyle(color: Colors.black),
                          )
                        : Text(
                            widget.creationTime.toDate().hour.toString() +
                                ":" +
                                widget.creationTime.toDate().minute.toString(),
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
