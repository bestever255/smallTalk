import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/pages/matches.dart';
import 'package:tinder_clone/ui/pages/messages.dart';
import 'package:tinder_clone/ui/pages/search.dart';
import 'package:tinder_clone/ui/widgets/profile_drawer.dart';

class Tabs extends StatefulWidget {
  final String userId;
  Tabs(this.userId);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AuthenticationBloc _authenticationBloc;
  String photoUrl;
  String storedPhotoUrl;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc();
    print('Online');
    _animationController = AnimationController(
      duration: Duration(seconds: 7),
      vsync: this,
    );
    _animationController.repeat();
    _authenticationBloc.add(UserOpenedApp(userId: widget.userId));
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    _animationController.dispose();
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
    var height = MediaQuery.of(context).size.height;

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
          backgroundColor: Colors.white,
          drawer: ProfileDrawer(widget.userId),
          appBar: AppBar(
            leading: Builder(
              builder: (ctx) {
                return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    cubit: _authenticationBloc,
                    builder: (context, state) {
                      if (state is PhotoLoading) {
                        return IconButton(
                            icon: Icon(Icons.person),
                            onPressed: () => Scaffold.of(context).openDrawer());
                      } else if (state is PhotoLoaded) {
                        photoUrl = state.photoUrl;
                        return IconButton(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            color: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: AnimatedBuilder(
                              animation: _animationController,
                              builder: (ctx, _widget) {
                                return Transform.rotate(
                                  angle: _animationController.value * 6.3,
                                  child: _widget,
                                );
                              },
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                  photoUrl,
                                ),
                              ),
                            ),
                            onPressed: () => Scaffold.of(context).openDrawer());
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    });
              },
            ),
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
              preferredSize: Size.fromHeight(height * .07),
              child: Container(
                height: height * .08,
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
