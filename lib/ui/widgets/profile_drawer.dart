import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/pages/profile_page.dart';

// ignore: must_be_immutable
class ProfileDrawer extends StatelessWidget {
  final String userId;
  ProfileDrawer(this.userId);

  UserRepository _userRepository = UserRepository();
  User _user = User();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey[200],
            child: FutureBuilder<User>(
                future: _userRepository.getUserProfile(currentUserId: userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _user = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(_user.photo),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                _user.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          ListTile(
                            title: Text('Profile'),
                            leading: Icon(
                              Icons.person_rounded,
                              color: Colors.grey[400],
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (ctx) => ProfilePage(userId),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Messages'),
                            leading: Icon(
                              Icons.mail_rounded,
                              color: Colors.grey[400],
                            ),
                          ),
                          Divider(thickness: 1),
                          ListTile(
                            title: Text('Settings'),
                            leading: Icon(
                              Icons.settings_rounded,
                              color: Colors.grey[400],
                            ),
                          ),
                          ListTile(
                            title: Text('About Us'),
                            leading: Icon(
                              Icons.group,
                              color: Colors.grey[400],
                            ),
                          ),
                          ListTile(
                            title: Text('Sign out'),
                            leading: Icon(
                              Icons.logout,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),
    );
  }
}
