import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/user_repository.dart';

import '../photo_widget.dart';

class MessagePageAppBar extends StatelessWidget {
  final User selectedUser;
  MessagePageAppBar(this.selectedUser);
  final UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AppBar(
      backgroundColor: Color.fromRGBO(25, 23, 33, 1),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: width * .04,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  selectedUser.name,
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: _userRepository.isOnline(
                        selectedUserId: selectedUser.uid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          'Offline',
                          style: TextStyle(color: Colors.red),
                        );
                      } else if (snapshot.hasData) {
                        bool isOnline = snapshot.data.data()['isOnline'];
                        return Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: height * .02,
                          ),
                        );
                      } else {
                        return Container(width: 0, height: 0);
                      }
                    }),
              ],
            ),
          ),
          SizedBox(width: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: CircleAvatar(
              backgroundColor: Color.fromRGBO(
                22,
                21,
                28,
                1,
              ),
              radius: 20,
              child: PhotoWidget(
                selectedUser.photo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
