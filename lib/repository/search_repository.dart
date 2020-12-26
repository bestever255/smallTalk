import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_clone/models/user.dart';

class SearchRepository {
  final FirebaseFirestore _firestore;
  SearchRepository(
      {FirebaseFirestore firestore, SearchRepository searchRepository})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User> chooseUser(String currentUserId, String selectedUserId,
      String name, String photourl) async {
    // To show people to you
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('choosenList')
        .doc(selectedUserId)
        .set({});
    // to be shown to people
    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('choosenList')
        .doc(currentUserId)
        .set({});

    // Add user to your selected list
    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('selectedList')
        .doc(currentUserId)
        .set({
      'name': name,
      'photourl': photourl,
    });
    return getUser(currentUserId);
  }

  Future<User> passUser(String currentUserId, String selectedUserId) async {
    await _firestore
        .collection('users')
        .doc(selectedUserId)
        .collection('choosenList')
        .doc(currentUserId)
        .set({});

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('choosenList')
        .doc(selectedUserId)
        .set({});
    return getUser(currentUserId);
  }

  Future<User> getUserInterests(String userId) async {
    User currentUser = User();

    // get your info
    await _firestore.collection('users').doc(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photourl'];
      currentUser.gender = user['gender'];
      currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }

  Future<List<String>> getChoosenList(String userId) async {
    List<String> choosenList = [];
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('choosenList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          choosenList.add(doc.id);
        }
      }
    });
    return choosenList;
  }

  Future<User> getUser(String userId) async {
    User _user = User();
    List<String> choosenList = await getChoosenList(userId);
    User currentUser = await getUserInterests(userId);
    await _firestore.collection('users').get().then((users) {
      for (var user in users.docs) {
        if ((!choosenList.contains(user.id)) &&
            (user.id != userId) &&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)) {
          _user.uid = user.id;
          _user.name = user['name'];
          _user.photo = user['photourl'];
          _user.age = user['age'];
          _user.location = user['location'];
          _user.gender = user['gender'];
          _user.interestedIn = user['interestedIn'];
          break;
        }
      }
    });
    return _user;
  }
}
