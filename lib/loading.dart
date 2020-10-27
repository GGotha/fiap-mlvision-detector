import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color color;
  final Color textColor;

  const Loading({
    Key key,
    @required this.title,
    this.backgroundColor = Colors.black54,
    this.color = Colors.white,
    this.textColor = Colors.white,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Platform.isIOS
                ? CupertinoActivityIndicator()
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color,
                    ),
                  ),
            Container(
              height: 16.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
