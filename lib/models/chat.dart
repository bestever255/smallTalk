import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class ChatModel {
  String name;
  String photourl;
  String lastMessageSend;
  File lastMessagePhoto;
  Timestamp timestamp;

  ChatModel({
    @required this.name,
    @required this.photourl,
    @required this.lastMessageSend,
    @required this.lastMessagePhoto,
    @required this.timestamp,
  });
}
