import 'package:flutter/material.dart';
import 'package:super_lista/blocs/my_app_bar.dart';

class AvaliableScreen {
  late double screenHeight;
  late double screenWidth;
  late double offsetTop;
  late double offsetBottom;
  late double offsetLeft;
  late double offsetRight;

  AvaliableScreen(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    screenHeight = mediaQuery.size.height;
    screenWidth = mediaQuery.size.width;

    offsetTop = mediaQuery.padding.top + myAppBar().preferredSize.height;
    offsetBottom = mediaQuery.padding.bottom;
    offsetLeft = mediaQuery.padding.left;
    offsetRight = mediaQuery.padding.right;
  }

  double vh(int percentage) {
    return (screenHeight - offsetTop - offsetBottom) * (percentage / 100);
  }

  double vw(int percentage) {
    return (screenWidth - offsetLeft - offsetRight) * (percentage / 100);
  }
}
