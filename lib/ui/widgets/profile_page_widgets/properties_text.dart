import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user.dart';

class PropertiesText extends StatelessWidget {
  final User user;
  PropertiesText(this.user);
  String formateAge(Timestamp age) {
    String realAge = (DateTime.now().year - age.toDate().year).toString();
    return realAge;
  }

  // TODO make this page dynamic by taking this info from user
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(text: '${formateAge(user.age)} y.o'),
          TextSpan(
            text: ' | ',
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
          TextSpan(text: '5\'4\'\' Height'),
          TextSpan(
            text: ' | ',
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
          TextSpan(text: '5 Matches')
        ],
      ),
    );
  }
}
