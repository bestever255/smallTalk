import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:tinder_clone/bloc/bloc/matches/bloc/matches_bloc.dart';
import 'package:tinder_clone/bloc/bloc/search/bloc/search_bloc.dart' as search;
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/matches_repository.dart';
import 'package:tinder_clone/ui/pages/messaging_page.dart';
import 'package:tinder_clone/ui/widgets/icon_widget.dart';
import 'package:tinder_clone/ui/widgets/profile_widget.dart';
import 'package:tinder_clone/ui/widgets/user_gender.dart';

class Matches extends StatefulWidget {
  final String userId;
  Matches(this.userId);

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  // MatchesRepository _matchesRepository = MatchesRepository();
  // MatchesBloc _matchesBloc;
  // search.SearchBloc _searchBloc;
  int difference;
  MatchesBloc _matchesBloc;
  search.SearchBloc _searchBloc;
  MatchesRepository _matchesRepository;

  @override
  void initState() {
    super.initState();
    _matchesBloc = GetIt.I.get<MatchesBloc>();
    _searchBloc = GetIt.I.get<search.SearchBloc>();
    _matchesRepository = GetIt.I.get<MatchesRepository>();
  }

  @override
  void dispose() {
    _matchesBloc.close();
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<MatchesBloc, MatchesState>(
      cubit: _matchesBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          _matchesBloc.add(LoadListEvent(
            userId: widget.userId,
          ));
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadUserState) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                title: Text(
                  'Matched users',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: state.matchedList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  } else if (snapshot.data.docs != null) {
                    final user = snapshot.data.docs;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await _matchesRepository
                                  .getUserDetails(user[index].documentID);
                              User currentUser = await _matchesRepository
                                  .getUserDetails(widget.userId);
                              await _searchBloc.getDifference(
                                  selectedUser.location, difference);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: ProfileWidget(
                                      photo: selectedUser.photo,
                                      photoHeight: height,
                                      photoWidth: width,
                                      padding: height * .01,
                                      clipRadius: height * .01,
                                      containerWidth: width,
                                      containerHeight: height * .2,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: height * .02,
                                        ),
                                        child: ListView(
                                          children: [
                                            SizedBox(
                                              height: height * .02,
                                            ),
                                            Row(
                                              children: [
                                                UserGender(selectedUser.gender),
                                                Expanded(
                                                  child: Text(
                                                    ' ' +
                                                        selectedUser.name +
                                                        ', ' +
                                                        (DateTime.now().year -
                                                                selectedUser.age
                                                                    .toDate()
                                                                    .year)
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: height * .05,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  difference != null
                                                      ? (difference / 1000)
                                                              .floor()
                                                              .toString() +
                                                          ' km away'
                                                      : 'away',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * .01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                    height * .02,
                                                  ),
                                                  child: IconWidget(
                                                    icon: Icons.message,
                                                    color: Colors.white,
                                                    size: height * .04,
                                                    onTap: () {
                                                      _matchesBloc.add(
                                                        OpenChatEvent(
                                                          currentUser:
                                                              widget.userId,
                                                          selectedUser:
                                                              selectedUser.uid,
                                                        ),
                                                      );
                                                      // Then Navigate To Chat Widget
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              MessagingPage(
                                                            currentUser,
                                                            selectedUser,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: ProfileWidget(
                              padding: height * .01,
                              photo: user[index].data()['photourl'],
                              photoHeight: height * .3,
                              photoWidth: width * .5,
                              clipRadius: height * .01,
                              containerHeight: height * .03,
                              containerWidth: width * .5,
                              child: Text(
                                ' ' + user[index].data()['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: user.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                },
              ),
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                title: Text(
                  'Someone Likes You',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: state.selectedList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                  if (snapshot.data.docs != null) {
                    final user = snapshot.data.docs;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await _matchesRepository
                                  .getUserDetails(user[index].id);
                              User currentUser = await _matchesRepository
                                  .getUserDetails(widget.userId);

                              await _searchBloc.getDifference(
                                  selectedUser.location, difference);
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: ProfileWidget(
                                    padding: height * .01,
                                    photoHeight: height,
                                    photoWidth: width,
                                    clipRadius: height * .01,
                                    photo: selectedUser.photo,
                                    containerHeight: height * .2,
                                    containerWidth: width,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: height * .02,
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                Row(
                                                  children: [
                                                    UserGender(
                                                        selectedUser.gender),
                                                    Expanded(
                                                      child: Text(
                                                        ' ' +
                                                            selectedUser.name +
                                                            ', ' +
                                                            (DateTime.now()
                                                                        .year -
                                                                    selectedUser
                                                                        .age
                                                                        .toDate()
                                                                        .year)
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              height * .05,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      difference != null
                                                          ? (difference / 1000)
                                                                  .floor()
                                                                  .toString() +
                                                              ' km away'
                                                          : 'away',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * .01,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconWidget(
                                                      icon: Icons.clear,
                                                      size: height * 0.08,
                                                      color: Colors.blue,
                                                      onTap: () {
                                                        _matchesBloc.add(
                                                          DeleteUserEvent(
                                                            currentUser:
                                                                currentUser.uid,
                                                            selectedUser:
                                                                selectedUser
                                                                    .uid,
                                                          ),
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: width * .05,
                                                    ),
                                                    IconWidget(
                                                      icon: FontAwesomeIcons
                                                          .solidHeart,
                                                      size: height * .06,
                                                      color: Colors.red,
                                                      onTap: () {
                                                        _matchesBloc.add(
                                                          AcceptUserEvent(
                                                            selectedUser:
                                                                selectedUser
                                                                    .uid,
                                                            currentUser:
                                                                currentUser.uid,
                                                            currentUserPhotoUrl:
                                                                currentUser
                                                                    .photo,
                                                            currentUserName:
                                                                currentUser
                                                                    .name,
                                                            selectedUserPhotoUrl:
                                                                selectedUser
                                                                    .photo,
                                                            selectedUserName:
                                                                selectedUser
                                                                    .name,
                                                          ),
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ProfileWidget(
                              padding: height * .01,
                              photo: user[index].data()['photourl'],
                              photoHeight: height * .3,
                              photoWidth: width * .5,
                              clipRadius: height * .01,
                              containerHeight: height * .03,
                              containerWidth: width * .5,
                              child: Text(
                                ' ' + user[index].data()['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: user.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    );
                  } else
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
