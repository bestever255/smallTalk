import 'package:flutter/material.dart';
import 'package:tinder_clone/ui/widgets/photo_widget.dart';

class ProfileWidget extends StatelessWidget {
  final double padding;
  final double photoHeight;
  final double photoWidth;
  final double clipRadius;
  final String photo;
  final double containerHeight;
  final double containerWidth;
  final Widget child;

  const ProfileWidget({
    @required this.padding,
    @required this.photoHeight,
    @required this.photoWidth,
    @required this.clipRadius,
    @required this.photo,
    @required this.containerHeight,
    @required this.containerWidth,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: Offset(
                // make shadow on the right
                10.0,
                // make shadow at the bottom
                10.0,
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(clipRadius),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              width: photoWidth,
              height: photoHeight,
              // Makes the photo widget edges rounded
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  clipRadius,
                ),
                child: PhotoWidget(photo),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.black54,
                  Colors.black87,
                  Colors.black
                ], stops: [
                  0.1,
                  0.2,
                  0.4,
                  0.9,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(clipRadius),
                  bottomRight: Radius.circular(clipRadius),
                ),
              ),
              width: containerWidth,
              height: containerHeight,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
