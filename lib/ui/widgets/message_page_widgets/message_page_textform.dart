import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_clone/bloc/bloc/messaging/messaging_bloc.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/messaging_repository.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/pages/messaging_page.dart';

class MessagePageTextForm extends StatefulWidget {
  final User currentUser;
  final User selectedUser;
  MessagePageTextForm(
      {@required this.currentUser, @required this.selectedUser});
  @override
  _MessagePageTextFormState createState() => _MessagePageTextFormState();
}

class _MessagePageTextFormState extends State<MessagePageTextForm> {
  TextEditingController _messageController;
  MessagingRepository _messagingRepository;
  bool isValid = false;
  MessagingBloc _messagingBloc;

  bool get isPopulated => _messageController.text.isNotEmpty;

  bool isSubmitButtonEnabled(MessagingPage state) {
    return isPopulated;
  }

  @override
  void initState() {
    super.initState();
    _messagingRepository = MessagingRepository();
    _messagingBloc = MessagingBloc(messagingRepository: _messagingRepository);
    _messageController = TextEditingController();
    _messageController.text = '';
    _messageController.addListener(() {
      setState(() {
        isValid = (_messageController.text.isEmpty) ? false : true;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messagingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height * .07,
              padding: EdgeInsets.all(
                height * .01,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(57, 47, 85, 1),
                borderRadius: BorderRadius.circular(
                  height * .04,
                ),
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _messageController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: kBackGroundColor,
                  onSubmitted: (_) {
                    setState(() {
                      _messageController.text = '';
                    });
                  },
                  decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: TextStyle(color: Colors.grey[100]),
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final pickedFile = await ImagePicker().getImage(
                                source: ImageSource.gallery, imageQuality: 85);
                            if (pickedFile != null) {
                              File photo = File(pickedFile.path);

                              if (photo != null) {
                                _messagingBloc.add(
                                  SendMessageEvent(
                                    message: Message(
                                      text: null,
                                      senderName: widget.currentUser.name,
                                      senderId: widget.currentUser.uid,
                                      photos: photo,
                                      selectedUserId: widget.selectedUser.uid,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              Navigator.of(context).pop();
                            }
                          }),
                      suffixIcon: Icon(
                        Icons.face_rounded,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(width: width * .03),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromRGBO(57, 47, 85, 1),
            ),
            child: Center(
              child: _messageController.text != ''
                  ? IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: isValid
                          ? () => _messagingBloc.onFormSubmitted(
                                currentUserId: widget.currentUser.uid,
                                currentUserName: widget.currentUser.name,
                                messagingBloc: _messagingBloc,
                                selectedUserId: widget.selectedUser.uid,
                                textEditingController: _messageController,
                              )
                          : null)
                  : IconButton(
                      icon: Icon(
                        Icons.mic_none_outlined,
                        color: Colors.white,
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
