import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_clone/models/user.dart';

class MatchesRepository {
  final FirebaseFirestore _firestore;
  MatchesRepository(
      {FirebaseFirestore firestore, MatchesRepository matchesRepository})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMatchedList(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('matchedList')
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('selectedList')
        .snapshots();
  }

  Future<User> getUserDetails(String userId) async {
    User _user = User();
    await _firestore.collection('users').doc(userId).get().then((value) {
      _user.uid = value.id;
      _user.name = value['name'];
      _user.age = value['age'];
      _user.gender = value['gender'];
      _user.location = value['location'];
      _user.interestedIn = value['interestedIn'];
      _user.photo = value['photourl'];
    });
    return _user;
  }

  Future openChat({String currentUserId, String selectedUserId}) async {
    // Add Both of you to chat firebase
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .set({
      'timestamp': DateTime.now(),
    });

    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('chats')
        .doc(currentUserId)
        .set({
      'timestamp': DateTime.now(),
    });
    // Delete From Matched Users
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .delete();
    // Delete You From his database
    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .delete();
  }

  void deleteUser(String currentUserId, String selectedUserId) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('selectedList')
        .doc(selectedUserId)
        .delete();
  }

  Future selectUser(
      String currentUserId,
      String selectedUserId,
      String currentUserName,
      String currentUserPhotoUrl,
      String selectedUserName,
      String selectedUserPhotoUrl) async {
    // Delete from selected list
    deleteUser(currentUserId, selectedUserId);
    // Add both of you to matched list
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('matchedList')
        .doc(selectedUserId)
        .set({
      'name': selectedUserName,
      'photourl': selectedUserPhotoUrl,
    });

    return await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('matchedList')
        .doc(currentUserId)
        .set({
      'name': currentUserName,
      'photourl': currentUserPhotoUrl,
    });
  }
}
