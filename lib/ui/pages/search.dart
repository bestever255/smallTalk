import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tinder_clone/bloc/bloc/search/bloc/search_bloc.dart';
import 'package:tinder_clone/models/user.dart';
import 'package:tinder_clone/repository/search_repository.dart';
import 'package:tinder_clone/ui/widgets/icon_widget.dart';
import 'package:tinder_clone/ui/widgets/profile_widget.dart';
import 'package:tinder_clone/ui/widgets/user_gender.dart';

class Search extends StatefulWidget {
  final String userId;
  Search(this.userId);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  Future<void> getDifference(GeoPoint userLocation) async {
    try {
      // Get Your current Position
      Position position = await Geolocator.getCurrentPosition();
      // Get Other user location and calculate difference
      double location = Geolocator.distanceBetween(userLocation.latitude,
          userLocation.longitude, position.latitude, position.longitude);

      difference = location.toInt();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(searchRepository: _searchRepository);
  }

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(LoadUserEvent(widget.userId));
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
          // User Loaded
        } else if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.blueGrey,
              ),
            ),
          );
        } else if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;

          getDifference(_user.location);
          if (_user.location == null) {
            return Center(
              child: Text(
                'No One Here',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ProfileWidget(
              padding: height * .035,
              photoHeight: height * .824,
              photoWidth: width * .95,
              clipRadius: height * .02,
              photo: _user.photo,
              containerHeight: height * .3,
              containerWidth: width * 0.9,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * .02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height * .1,
                    ),
                    Row(
                      children: <Widget>[
                        UserGender(_user.gender),
                        Expanded(
                          child: Text(
                            ' ' +
                                _user.name +
                                ', ' +
                                // Print User Age
                                (DateTime.now().year - _user.age.toDate().year)
                                    .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * .04,
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
                              ? (difference / 1000).floor().toString() +
                                  " Km away"
                              : 'Away',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconWidget(
                          icon: EvaIcons.flash,
                          size: height * .04,
                          color: Colors.yellow,
                          onTap: () {},
                        ),
                        IconWidget(
                          icon: Icons.clear,
                          color: Colors.blue,
                          size: height * .08,
                          onTap: () => _searchBloc.add(
                            PassUserEvent(widget.userId, _user.uid),
                          ),
                        ),
                        IconWidget(
                          icon: FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: height * .06,
                          onTap: () => _searchBloc.add(
                            SelectUserEvent(widget.userId, _currentUser.name,
                                _currentUser.photo, _user.uid),
                          ),
                        ),
                        IconWidget(
                          icon: EvaIcons.options2,
                          color: Colors.white,
                          size: height * 0.04,
                          onTap: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
