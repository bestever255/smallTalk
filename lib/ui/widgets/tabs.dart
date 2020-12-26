import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/pages/matches.dart';
import 'package:tinder_clone/ui/pages/messages.dart';
import 'package:tinder_clone/ui/pages/search.dart';

class Tabs extends StatelessWidget {
  final String userId;
  Tabs(this.userId);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Search(userId),
      Matches(userId),
      Messages(),
    ];
    return Theme(
      data: ThemeData(
        primaryColor: kBackGroundColor,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(
        length: pages.length,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  }),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          icon: Icon(Icons.search),
                        ),
                        Tab(
                          icon: Icon(Icons.people),
                        ),
                        Tab(
                          icon: Icon(Icons.message),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              'Chill',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
