import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserRepository(
      {FirebaseAuth firebaseAuth, FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print(response);
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist = false;
    await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => {exist = value.exists});

    return exist;
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      // ignore: unused_local_variable
      final response = await _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }

  // to know if someone logged in before so we dont make him type email and password again
  Future<bool> isSignedIn() async {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }

  Future<String> getUser() async {
    final id = _firebaseAuth.currentUser.uid;
    return id;
  }

  // profile setup
  Future<void> profileSetup(
      {@required File photo,
      @required String userId,
      @required String name,
      @required String gender,
      @required String interestedIn,
      @required DateTime age,
      @required GeoPoint location}) async {
    UploadTask uploadTask;
    uploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(userId)
        .child(userId)
        .putFile(photo);

    return await uploadTask.then((snapshot) async {
      await snapshot.ref.getDownloadURL().then((url) async {
        await _firestore.collection('users').doc(userId).set({
          'uid': userId,
          'photourl': url,
          'name': (name[0].toUpperCase() + name.substring(1).toLowerCase()),
          'location': location,
          'gender': gender,
          'interestedIn': interestedIn,
          'age': age,
        });
      });
    });
  }
}
