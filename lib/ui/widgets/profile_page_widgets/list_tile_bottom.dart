import 'package:flutter/material.dart';

class ListTileBottom extends StatelessWidget {
  final String text;
  final IconData icon;
  const ListTileBottom(this.text, this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
