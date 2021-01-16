import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_clone/models/message.dart';
import 'package:tinder_clone/models/user.dart';

class MessageRepository {
  final FirebaseFirestore _firestore;
  MessageRepository(
      {FirebaseFirestore firestore, MessageRepository messageRepository})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Fetch List of Message like you have a list of chat with karim , mazen , moustfa etc..
  Stream<QuerySnapshot> getChats({String userId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteChat({String currentUserId, String selectedUserId}) async {
    return await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .delete();
  }

  Future<User> getUserDetail({String userId}) async {
    User _user = User();
    await _firestore.collection('users').doc(userId).get().then((value) {
      _user.uid = value.id;
      _user.age = value['age'];
      _user.gender = value['gender'];
      _user.interestedIn = value['interestedIn'];
      _user.photo = value['photourl'];
      _user.name = value['name'];
      _user.location = value['location'];
    });
    return _user;
  }

  // Get last message so we can show it outside the chat...
  Future<Message> getLastMessage(
      {String currentUserId, String selectedUserId}) async {
    Message _message = Message();
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
          .get()
          .then((message) {
        _message.text = message.data()['text'];
        _message.photourl = message.data()['photourl'];
        _message.timestamp = message.data()['timestamp'];
      });
    }).catchError((e) => print(e));
    return _message;
  }
}
