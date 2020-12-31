import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tinder_clone/models/message.dart' as mes;
import 'package:tinder_clone/repository/messaging_repository.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/message_bubble.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

class MessageWidget extends StatefulWidget {
  final String messageId;
  final String currentUserId;

  const MessageWidget({this.messageId, this.currentUserId});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepository _messagingRepository = MessagingRepository();
  mes.Message _message;

  Future<mes.Message> getDetails() async {
    _message = (await _messagingRepository.getMessageDetail(
        messageId: widget.messageId));
    return _message;
  }

  bool get isMe => _message.senderId == widget.currentUserId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          _message = snapshot.data;
          return Column(
            // Make Chat on the right
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              _message.text != null
                  ? MessageBubble(
                      isMe: isMe,
                      message: _message,
                    )
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        isMe
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: height * .01,
                                ),
                                child: Text(
                                  timeago.format(
                                    _message.timestamp.toDate(),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * .01,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: height * .8,
                              maxWidth: width * .7,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kBackGroundColor),
                                borderRadius:
                                    BorderRadius.circular(height * .2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  height * .02,
                                ),
                                child: PhotoWidget(_message.photourl),
                              ),
                            ),
                          ),
                        ),
                        isMe
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * .01),
                                child: Text(
                                  timeago.format(
                                    _message.timestamp.toDate(),
                                  ),
                                ),
                              ),
                      ],
                    ),
            ],
          );
        }
      },
    );
  }
}
