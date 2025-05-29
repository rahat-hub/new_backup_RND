import 'dart:ui';

import 'package:flutter/material.dart';

final FlutterView? window = WidgetsBinding.instance.platformDispatcher.implicitView; //PlatformDispatcher.instance.implicitView
Size size = window!.physicalSize / window!.devicePixelRatio;

/// This method is used to set padding/margin (for the left and Right side)
/// and width of the screen or widget according to the Viewport width.
double getHorizontalSize(double px) => px * (size.width / 375);

/// This method is used to set padding/margin (for the top and bottom side)
/// and height of the screen or widget according to the Viewport height.
double getVerticalSize(double px) {
  final num statusBar = MediaQueryData.fromView(window!).viewPadding.top;
  final num screenHeight = size.height - statusBar;
  return px * (screenHeight / 812);
}

/// This method is used to set smallest px in image height and width.
double getSize(double px) {
  final double height = getVerticalSize(px);
  final double width = getHorizontalSize(px);

  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

/// This method is used to set text font size according to Viewport.
double getFontSize(double px) => getSize(px);
