import 'package:flutter/material.dart';

class Gender extends StatelessWidget {
  final Function onTab;
  final IconData icon;
  final String selected;
  final String text;

  const Gender(
      {@required this.onTab,
      @required this.icon,
      @required this.selected,
      @required this.text});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTab,
      child: Column(
        children: [
          Icon(icon,
              size: height * 0.11,
              color: selected == text ? Colors.white : Colors.black54),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            text,
            style: TextStyle(
              color: selected == text ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
