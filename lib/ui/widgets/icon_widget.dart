import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final double size;
  final Color color;

  const IconWidget({this.icon, this.onTap, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}
