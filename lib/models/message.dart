import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderName;
  String senderId;
  String selectedUserId;
  String text;
  String photourl;
  File photos;
  Timestamp timestamp;

  Message({
    this.senderName,
    this.senderId,
    this.selectedUserId,
    this.text,
    this.photourl,
    this.photos,
    this.timestamp,
  });

  @override
  String toString() {
    return 'Message senderName: $senderName , senderId: $senderId , selectedUserId: $selectedUserId , text: $text , photourl: $photourl , photos: $photos , timestamp: $timestamp';
  }
}
