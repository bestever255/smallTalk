import 'package:flutter/material.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/widgets/profile_page_widgets/Interested_in.dart';
import 'package:tinder_clone/ui/widgets/profile_page_widgets/list_tile_bottom.dart';
import 'package:tinder_clone/ui/widgets/profile_page_widgets/properties_text.dart';
import 'package:tinder_clone/ui/widgets/profile_page_widgets/status_message.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final String userId;
  ProfilePage(this.userId);
  UserRepository _userRepository = UserRepository();
  User _user = User();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<User>(
              future: _userRepository.getUserProfile(currentUserId: userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  _user = snapshot.data;
                  return Column(
                    children: [
                      Container(
                        height: height * .3,
                        width: width * .9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    height: height * .1,
                                    width: width * .2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(_user.photo),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          new Radius.circular(50.0)),
                                      border: Border.all(
                                        color: Colors.redAccent,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height * .02),
                                    Text(
                                      _user.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height * .01),
                                    Text(
                                      'Far Rockaway, NY',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    SizedBox(height: height * .01),
                                    PropertiesText(_user),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InterestedIn('Programming'),
                                  InterestedIn('Coding'),
                                  InterestedIn('Music'),
                                  InterestedIn('Games'),
                                ],
                              ),
                            ),
                            StatusMessage(
                                'Software Developer who loves flutter and dart ❤️💙'),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Container(
                          height: height * .15,
                          width: width * .15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              print('Pressed On Edit');
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                const ListTileBottom(
                                    'Detailed Info', Icons.info_outline),
                                const ListTileBottom(
                                    'Matches', Icons.favorite_outline),
                                const ListTileBottom('Profile Stats',
                                    Icons.stay_current_landscape_sharp),
                                const ListTileBottom(
                                    'Notes', Icons.notes_outlined),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
