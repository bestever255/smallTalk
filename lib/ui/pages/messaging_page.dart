import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/messaging/messaging_bloc.dart';
import 'package:tinder_clone/models/user.dart';

import 'package:tinder_clone/ui/widgets/message_page_widgets/message_page_appbar.dart';
import 'package:tinder_clone/ui/widgets/message_page_widgets/message_page_listview.dart';

class MessagingPage extends StatefulWidget {
  final User currentUser, selectedUser;
  MessagingPage(this.currentUser, this.selectedUser);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  MessagingBloc _messagingBloc;

  @override
  void initState() {
    super.initState();
    _messagingBloc = MessagingBloc();
  }

  @override
  void dispose() {
    _messagingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if widget.currentUser == recevier id && widget.selectedUser == senderId
    // && If selected user online && this is true then message is seen
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 23, 33, 1),
      appBar: PreferredSize(
        child: MessagePageAppBar(widget.selectedUser),
        preferredSize: Size.fromHeight(100),
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
        child: BlocProvider(
          create: (context) => MessagingBloc(),
          child: MessagePageListView(
            currentUser: widget.currentUser,
            selectedUser: widget.selectedUser,
          ),
        ),
      ),
    );
  }
}
