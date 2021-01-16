import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/messaging/messaging_bloc.dart';
import 'package:tinder_clone/models/message.dart' as mes;
import 'package:tinder_clone/repository/messaging_repository.dart';
import 'package:tinder_clone/ui/widgets/message_page_widgets/message_bubble.dart';
import 'package:tinder_clone/ui/widgets/message_page_widgets/photo_bubble.dart';

class MessageWidget extends StatefulWidget {
  final String messageId;
  final String currentUserId;
  final String selectedUserId;
  const MessageWidget(
      {@required this.messageId,
      @required this.currentUserId,
      @required this.selectedUserId});

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  MessagingRepository _messagingRepository = MessagingRepository();
  mes.Message _message;
  MessagingBloc _messagingBloc;

  Future<mes.Message> getDetails() async {
    _message = (await _messagingRepository.getMessageDetail(
        messageId: widget.messageId));
    return _message;
  }

  bool get isMe => _message.senderId == widget.currentUserId;

  @override
  void initState() {
    super.initState();
    _messagingBloc = MessagingBloc(messagingRepository: _messagingRepository);
  }

  @override
  void dispose() {
    super.dispose();
    _messagingBloc.close();
  }

  void messageAlerDialoge(Function onPressed) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Delete This Message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text('Are You Sure you need to delete this message?'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'NO',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    onPressed();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'YES',
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
      cubit: _messagingBloc,
      builder: (context, state) {
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
                      ? GestureDetector(
                          onLongPress: () => isMe
                              ? messageAlerDialoge(
                                  () => _messagingBloc.add(
                                    DeleteMessageEvent(
                                      messageId: widget.messageId,
                                      currentUserId: widget.currentUserId,
                                      selectedUserId: widget.selectedUserId,
                                    ),
                                  ),
                                )
                              : null,
                          child: MessageBubble(
                            isMe: isMe,
                            message: _message,
                            messageId: widget.messageId,
                          ),
                        )
                      : GestureDetector(
                          onLongPress: () => isMe
                              ? messageAlerDialoge(
                                  () => _messagingBloc.add(
                                    DeletePhotoEvent(
                                      messageId: widget.messageId,
                                      currentUserId: widget.currentUserId,
                                      selectedUserId: widget.selectedUserId,
                                    ),
                                  ),
                                )
                              : null,
                          child: PhotoBubble(
                            isMe: isMe,
                            message: _message,
                          ),
                        )
                ],
              );
            }
          },
        );
      },
    );
  }
}
