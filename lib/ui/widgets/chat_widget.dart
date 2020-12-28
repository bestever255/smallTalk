import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tinder_clone/models/chat.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/models/user.dart' as u;
import 'package:tinder_clone/repository/message_repository.dart';
import 'package:tinder_clone/ui/pages/messaging_page.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

// ignore: must_be_immutable
class ChatWidget extends StatelessWidget {
  final String userId;
  final String selectedUserId;
  final Timestamp creationTime;

  ChatWidget({this.userId, this.selectedUserId, this.creationTime});

  MessageRepository _messageRepository = MessageRepository();
  ChatModel _chat;
  u.User _user;

  Future<ChatModel> getUserDetails() async {
    _user = await _messageRepository.getUserDetail(userId: selectedUserId);
    Message message = await _messageRepository
        .getLastMessage(currentUserId: userId, selectedUserId: selectedUserId)
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
          lastMessagePhoto: message.photos,
          timestamp: message.timestamp);
    }
    return _chat;
  }

  Future openChat(BuildContext context) async {
    u.User currentUser = await _messageRepository.getUserDetail(userId: userId);
    u.User selectedUser =
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

  Future deleteChat() async {
    await _messageRepository.deleteChat(
      currentUserId: userId,
      selectedUserId: selectedUserId,
    );
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
              await openChat(context);
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
                            timeago.format(_chat.timestamp.toDate()),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            timeago.format(creationTime.toDate()),
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
