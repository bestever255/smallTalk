import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;
  bool isOnline;

  User({
    this.uid,
    this.name,
    this.gender,
    this.age,
    this.interestedIn,
    this.location,
    this.photo,
    this.isOnline,
  });
}
