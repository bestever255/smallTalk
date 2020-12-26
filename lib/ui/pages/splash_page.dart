import 'package:flutter/material.dart';
import 'package:tinder_clone/ui/constants.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackGroundColor,
      body: Container(
        width: width,
        child: Center(
          child: Text(
            'Chill',
            style: TextStyle(color: Colors.white, fontSize: width * 0.2),
          ),
        ),
      ),
    );
  }
}
