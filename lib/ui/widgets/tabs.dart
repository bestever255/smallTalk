import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/repository/user_repository.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/pages/matches.dart';
import 'package:tinder_clone/ui/pages/messages.dart';
import 'package:tinder_clone/ui/pages/search.dart';

class Tabs extends StatefulWidget {
  final String userId;
  Tabs(this.userId);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with WidgetsBindingObserver {
  AuthenticationBloc _authenticationBloc;
  UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    print('Online');
    _authenticationBloc.add(UserOpenedApp(userId: widget.userId));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('Online');
      _authenticationBloc.add(UserOpenedApp(userId: widget.userId));
    } else {
      _authenticationBloc.add(UserClosedApp(userId: widget.userId));
      print('Offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Matches(widget.userId),
      Search(widget.userId),
      Messages(
        userId: widget.userId,
      ),
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
            shadowColor: Colors.transparent,
            elevation: 0,
            backgroundColor: Colors.grey[850],
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  }),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TabBar(
                      indicatorColor: Colors.transparent,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.people),
                        ),
                        Tab(
                          icon: Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                          ),
                        ),
                        Tab(
                          icon: Icon(Icons.chat_bubble_outline_sharp),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
