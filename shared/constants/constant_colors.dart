import 'package:flutter/material.dart';

class ColorConstants {
  static const Color background = Color(0xFFF3F6F7); //Color(0xFFF2F5F6);
  static const Color button = Color(0xFF4BAE50);
  static const Color icon = Color(0xFF05B985);
  static const Color primary = Color(0xFF007DB8); //Color(0xFF017DC1);
  static const Color text = Color(0xFF323143);
  static const Color tableHeader = Color(0xFF4BAE50);

  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF8C97A8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFEB0000); //Color(0xFFFD3131);
  static const Color orange = Color(0xFFFF7400);
  static const Color yellow = Color(0xFFFFC800);
  static const Color green = Color(0xFF6B8449);
  static const Color blue = Color(0xFF4A89DC);
  static const Color transparent = Color(0x00000000);
}

/// Convert hex color to Color object with support for alpha channel.
/// if alpha channel is not provided, it will default to 0xFF.
///
/// hex color must be #RRGGBB or #RRGGBBAA format,
/// Example: hexToColor('#FF0000') or hexToColor('#FF0000FF') for red color,
///
/// Example: hexToColor('#00FF00') or hexToColor('#00FF00FF') for green color,
///
/// Example: hexToColor('#0000FF') or hexToColor('#0000FFFF') for blue color
Color hexToColor(String hex) {
  assert(RegExp(r'^#([\da-fA-F]{6})|([\da-fA-F]{8})$').hasMatch(hex), 'hex color must be #RRGGBB or #RRGGBBAA');

  return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xff000000 : 0x00000000));
}
