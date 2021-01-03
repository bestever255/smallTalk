import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:uuid/uuid.dart';

class MessagingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository({
    FirebaseFirestore firestore,
    FirebaseStorage firebaseStorage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future sendMessage({@required Message message}) async {
    UploadTask _uploadTask;
    DocumentReference messageRef = _firestore.collection('messages').doc();
    CollectionReference senderRef = _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .collection('messages');

    CollectionReference sendUserRef = _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    // If the user sends a photo
    if (message.photos != null) {
      Reference photoRef = _firebaseStorage
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);
      _uploadTask = photoRef.putFile(message.photos);
      await _uploadTask.then((photo) {
        photoRef.getDownloadURL().then((url) {
          messageRef.set({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photourl': url,
            'timestamp': DateTime.now(),
          });
        });
      });
    } else if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photourl': null,
        'timestamp': DateTime.now(),
      });
    }
    //  STOPPED AT 40
    senderRef.doc(messageRef.id).set({
      'timestamp': DateTime.now(),
    });

    sendUserRef.doc(messageRef.id).set({
      'timestamp': DateTime.now(),
    });
    await _firestore
        .collection('users')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.selectedUserId)
        .update({'timestamp': DateTime.now()});

    await _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .update({'timestamp': DateTime.now()});
  }

  Stream<QuerySnapshot> getMessages(
      {@required String currentUserId, @required String selectedUserId}) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({String messageId}) async {
    Message _message = Message();
    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      _message.senderId = message['senderId'];
      _message.senderName = message['senderName'];
      _message.timestamp = message['timestamp'];
      _message.text = message['text'];
      _message.photourl = message['photourl'];
    });
    return _message;
  }

  Future deleteMessage(
      {String messageId}) async {
    

    await _firestore.collection('messages').doc(messageId).delete();
  }
}
