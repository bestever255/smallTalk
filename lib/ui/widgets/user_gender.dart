import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserGender extends StatelessWidget {
  final String gender;
  UserGender(this.gender);
  @override
  Widget build(BuildContext context) {
    switch (gender) {
      case 'Male':
        return Icon(
          FontAwesomeIcons.mars,
          color: Colors.white,
        );
        break;
      case 'Female':
        return Icon(
          FontAwesomeIcons.venus,
          color: Colors.white,
        );
        break;
      case 'TransGender':
        return Icon(FontAwesomeIcons.transgender);
        break;
      default:
        return null;
        break;
    }
  }
}
