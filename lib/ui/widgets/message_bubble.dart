import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tinder_clone/models/message.dart' as mes;
import 'package:tinder_clone/ui/constants.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final mes.Message message;
  MessageBubble({this.isMe, this.message});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      children: [
        isMe
            ? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height * .01,
                ),
                child: Text(
                  timeago.format(
                    message.timestamp.toDate(),
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.all(
            height * .01,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width * .7,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isMe ? kBackGroundColor : Colors.grey[200],
                borderRadius: isMe
                    // Make Message design for me
                    ? BorderRadius.only(
                        topLeft: Radius.circular(height * .02),
                        topRight: Radius.circular(height * .02),
                        bottomLeft: Radius.circular(
                          height * .02,
                        ),
                      )
                    // Make Message design for user
                    : BorderRadius.only(
                        topLeft: Radius.circular(height * .02),
                        topRight: Radius.circular(height * .02),
                        bottomRight: Radius.circular(
                          height * .02,
                        ),
                      ),
              ),
              padding: EdgeInsets.all(height * .01),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        isMe
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height * .01,
                ),
                child: Text(
                  timeago.format(
                    message.timestamp.toDate(),
                  ),
                ),
              ),
      ],
    );
  }
}
