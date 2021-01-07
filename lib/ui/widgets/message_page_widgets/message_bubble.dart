import 'package:flutter/material.dart';
import 'package:tinder_clone/models/message.dart' as mes;

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final mes.Message message;
  final String messageId;
  MessageBubble({this.isMe, this.message, this.messageId});

  String timeFormat(mes.Message message) {
    String hour = (message.timestamp.toDate().hour).toString();
    String minute = (message.timestamp.toDate().minute).toString();
    if (minute.length == 1) {
      minute = '0' + (message.timestamp.toDate().minute).toString();
    }

    String time = hour + ':' + minute;
    return time;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width * .7,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Color.fromRGBO(
                        134,
                        101,
                        245,
                        1,
                      )
                    : Color.fromRGBO(
                        60,
                        50,
                        80,
                        1,
                      ),
                borderRadius: isMe
                    // Make Message design for me
                    ? BorderRadius.only(
                        topLeft: Radius.circular(height * .025),
                        topRight: Radius.circular(height * .025),
                        bottomLeft: Radius.circular(
                          height * .025,
                        ),
                      )
                    // Make Message design for user
                    : BorderRadius.only(
                        topLeft: Radius.circular(height * .025),
                        topRight: Radius.circular(height * .025),
                        bottomRight: Radius.circular(
                          height * .025,
                        ),
                      ),
              ),
              padding: EdgeInsets.all(height * .02),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                isMe ? 'Sent' : '',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                width: width * .02,
              ),
              Text(
                timeFormat(message),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
