import 'package:flutter/material.dart';

double? heightPx({required double height, required double value}) => height / (15 * 2) * value;

//720 / (30*0.5) //1090px //433px
//720 / (30*1)
//720 / (30*2)

// var v  = 720/15; SizeBox(height = 1080/15),
// var v  = 1080/15;

//720px
//8:2
//8/2
//8 = full screen size
//2 = dynamic divide value

double? widthPx({required double width, required double value}) => width / (15 * 2) * value;

class AdaptiveTextSize {
  const AdaptiveTextSize._();

  /// 720 is medium screen height
  double getAdaptiveTextSize(BuildContext? context, double value, double mediaQueryHeight) => (value / 720) * mediaQueryHeight;
}

class AdaptiveIconSize {
  const AdaptiveIconSize._();

  /// 720 is medium screen height
  double getIconSize(BuildContext? context, double value, double mediaQueryHeight) => (value / 720) * mediaQueryHeight;
}
