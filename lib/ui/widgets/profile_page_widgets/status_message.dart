import 'package:flutter/material.dart';

class StatusMessage extends StatelessWidget {
  final String statusText;
  StatusMessage(this.statusText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Text(
            statusText,
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
