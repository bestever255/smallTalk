import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/messaging/messaging_bloc.dart';
import 'package:tinder_clone/models/message.dart' as mes;
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/messaging_repository.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/message_widget.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

class MessagingPage extends StatefulWidget {
  final User currentUser, selectedUser;
  MessagingPage(this.currentUser, this.selectedUser);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  MessagingRepository _messagingRepository = MessagingRepository();
  MessagingBloc _messagingBloc;
  TextEditingController _messageController;
  bool isValid = false;

  bool get isPopulated => _messageController.text.isNotEmpty;
  bool isSubmitButtonEnabled(MessagingPage state) {
    return isPopulated;
  }

  @override
  void initState() {
    super.initState();
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
    _messagingBloc.close();
    _messageController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    print('Message Submitted');
    _messagingBloc.add(
      SendMessageEvent(
        message: mes.Message(
          text: _messageController.text.trim(),
          senderId: widget.currentUser.uid,
          senderName: widget.currentUser.name,
          selectedUserId: widget.selectedUser.uid,
          photos: null,
        ),
      ),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        elevation: height * .02,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: height * .03,
              backgroundColor: kBackGroundColor,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  height * .02,
                ),
                child: PhotoWidget(
                  widget.selectedUser.photo,
                ),
              ),
            ),
            SizedBox(
              width: width * .03,
            ),
            Expanded(
              child: Text(
                widget.selectedUser.name,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        bloc: _messagingBloc,
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
                      return Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemBuilder: (ctx, i) {
                                  return MessageWidget(
                                    currentUserId: widget.currentUser.uid,
                                    messageId: snapshot.data.docs[i].id,
                                  );
                                },
                                itemCount: snapshot.data.docs.length,
                              ),
                            ),
                          ],
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
                Container(
                  width: width,
                  height: height * .06,
                  color: kBackGroundColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            File photo = File(result.files.single.path);

                            if (photo != null) {
                              _messagingBloc.add(
                                SendMessageEvent(
                                  message: mes.Message(
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
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: height * .005,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: height * .04,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: height * .05,
                          padding: EdgeInsets.all(
                            height * .01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              height * .04,
                            ),
                          ),
                          child: Center(
                            child: TextField(
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
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          height * .01,
                        ),
                        child: GestureDetector(
                          onTap: isValid ? _onFormSubmitted : null,
                          child: Icon(
                            Icons.send,
                            color: isValid ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
