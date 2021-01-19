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
            'receiverId': message.selectedUserId,
            'text': null,
            'photourl': url,
            'timestamp': DateTime.now(),
            'isSeen': false,
            'isTyping': false,
          });
        });
      });
    } else if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'receiverId': message.selectedUserId,
        'text': message.text,
        'photourl': null,
        'isSeen': false,
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
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<Message> getMessageDetail({String messageId}) async {
    Message _message = Message();
    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      _message.senderId = message.data()['senderId'];
      _message.selectedUserId = message.data()['receiverId'];
      _message.senderName = message.data()['senderName'];
      _message.timestamp = message.data()['timestamp'];
      _message.text = message.data()['text'];
      _message.photourl = message.data()['photourl'];
      _message.isSeen = message.data()['isSeen'];
      _message.isTyping = message.data()['isTyping'];
    });
    return _message;
  }

  Future deleteMessage(
      {@required String messageId,
      @required String currentUserId,
      @required String selectedUserId}) async {
    await _firestore.collection('messages').doc(messageId).delete();
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future deletePhoto(
      {@required String messageId,
      String currentUserId,
      String selectedUserId}) async {
    String downloadUrl;
    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      downloadUrl = message.data()['photourl'];
    });

    await FirebaseStorage.instance.refFromURL(downloadUrl).delete();

    await deleteMessage(
        messageId: messageId,
        currentUserId: currentUserId,
        selectedUserId: selectedUserId);
  }

  Future messageSeen(
      {@required String messageId,
      @required String currentUserId,
      @required String selectedUserId,
      @required bool isInWidget}) async {
    String senderId;
    String receiverId;
    bool isOnline;
    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      senderId = message.data()['senderId'];
      receiverId = message.data()['receiverId'];
    });

    await _firestore.collection('users').doc(selectedUserId).get().then((user) {
      isOnline = user.data()['isOnline'];
    });

    if (currentUserId == receiverId &&
        selectedUserId == senderId &&
        isOnline &&
        isInWidget) {
      // Get Last Message
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .doc(selectedUserId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .first
          .then((doc) async {
        await _firestore
            .collection('messages')
            .doc(doc.docs.first.id)
            .update({'isSeen': true});
      });
    }
  }
}
