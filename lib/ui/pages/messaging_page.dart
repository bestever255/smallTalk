import 'dart:async';
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(
        25,
        23,
        33,
        1,
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(
          25,
          23,
          33,
          1,
        ),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: width * .04,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.selectedUser.name,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Last online at 10:45 PM',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(
                  22,
                  21,
                  28,
                  1,
                ),
                radius: 20,
                child: PhotoWidget(
                  widget.selectedUser.photo,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(
            40,
            33,
            56,
            .7,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
          ),
        ),
        child: BlocBuilder<MessagingBloc, MessagingState>(
          cubit: _messagingBloc,
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
                  Padding(
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[100]),
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          FilePickerResult result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.image);
                                          if (result != null) {
                                            File photo =
                                                File(result.files.single.path);

                                            if (photo != null) {
                                              _messagingBloc.add(
                                                SendMessageEvent(
                                                  message: mes.Message(
                                                    text: null,
                                                    senderName:
                                                        widget.currentUser.name,
                                                    senderId:
                                                        widget.currentUser.uid,
                                                    photos: photo,
                                                    selectedUserId:
                                                        widget.selectedUser.uid,
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
                                              currentUserId:
                                                  widget.currentUser.uid,
                                              currentUserName:
                                                  widget.currentUser.name,
                                              messagingBloc: _messagingBloc,
                                              selectedUserId:
                                                  widget.selectedUser.uid,
                                              textEditingController:
                                                  _messageController,
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
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
