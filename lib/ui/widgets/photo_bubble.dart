import 'package:flutter/material.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

class PhotoBubble extends StatelessWidget {
  final bool isMe;
  final Message message;

  const PhotoBubble({this.isMe, this.message});

  String timeFormat(Message message) {
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
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height * .8,
              maxWidth: width * .7,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kBackGroundColor),
                borderRadius: BorderRadius.circular(height * .2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  height * .02,
                ),
                child: PhotoWidget(message.photourl),
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
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
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
