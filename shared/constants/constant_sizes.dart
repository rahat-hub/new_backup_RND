import 'package:aviation_rnd/shared/services/device_orientation.dart';
import 'package:aviation_rnd/shared/utils/device_type.dart';
import 'package:aviation_rnd/shared/utils/text_size_scaling.dart';

abstract class SizeConstants {
  SizeConstants._();

  static const double rootContainerSpacing = 25;
  static const double contentSpacing = 10;
  static const double innerPadding = 15;
  static const double listItemRadius = 10;
  static const double gridItemRadius = 5;
  static const double boxRadius = 25; //10.0
  static const double iconContainerRadius = 15; //10.0
  static const double appBarRadius = 30;
  static const double elevation = 5;
  static const double buttonRadius = 5;
  static const double iconSize = 20;
  static const double textBoxRadius = 10;
  static const double dialogBoxRadius = 10;
  static const double switchBoxRadius = 5;

  //TEXT SIZE
  static const double appBarTitleExtraLarge = 45;
  static const double appBarTitleLarge = 25;
  static const double extraLargeText = 35;
  static const double largeText = 25;
  static const double dialogText = 18;
  static const double extraMediumText = 18;
  static const double mediumText = 15;
  static const double smallText = 12;
  static const double extraSmallText = 8;

  static const String title = "title";
  static const String title2 = "title2";
  static const String dialogTitle = "dialog_title";
  static const String subTitle = "subtitle";
  static const String body = "body";
  static const String hint = "hint";
  static const String button = "button";
  static const String appBarTitle = "appbar_title";
  static const String gridListTitle = "gridListTileFont";
  static const String manCatFont = "manCatFont";
  static const String extraSmallHint = "extraSmallHint";
  static const String smallHint = "smallHint";
  static const String dialogButtonText = "d_b_text";
  static const String tableHeaderText = "t_h_text";
  static const String tableRowText = "t_r_text";

  //icon
  static const String extraLargeIcon = "extra_large_icon";
  static const String largeIcon = "large_icon";
  static const String mediumIcon = "medium_icon";
  static const String smallIcon = "small_icon";
  static const String customIcon = "custom_icon";

  ///type = title,subtitle,body,hint,button,appbar_title
  static double fontSizes({required String type}) {
    double value = 0;

    if (DeviceType.isMobile) {
      if (DeviceOrientation.isPortrait) {
        //for portrait mobile
        switch (type) {
          case title:
            value = getFontSize(SizeConstants.largeText);

          case title2:
            value = getFontSize(SizeConstants.largeText);

          case dialogTitle:
            value = getFontSize(SizeConstants.dialogText);

          case subTitle:
            value = getFontSize(SizeConstants.mediumText + 2);

          case body:
            value = getFontSize(SizeConstants.mediumText);

          case hint:
            value = getFontSize(SizeConstants.smallText);

          case button:
            value = getFontSize(SizeConstants.mediumText + 1);

          case appBarTitle:
            value = getFontSize(SizeConstants.appBarTitleLarge);

          case gridListTitle:
            value = getFontSize(SizeConstants.extraMediumText);

          case manCatFont:
            value = getFontSize(SizeConstants.smallText);

          case extraSmallHint:
            value = getFontSize(SizeConstants.extraSmallText + 2);

          case smallHint:
            value = getFontSize(SizeConstants.extraSmallText + 5);

          case dialogButtonText:
            value = getFontSize(SizeConstants.mediumText + 2);

          case tableHeaderText:
            value = getFontSize(SizeConstants.extraMediumText);

          case tableRowText:
            value = getFontSize(SizeConstants.mediumText);

          default:
            value = getFontSize(SizeConstants.extraSmallText);
        }
      } else {
        //for landscape mobile
        switch (type) {
          case title:
            value = getFontSize(SizeConstants.extraMediumText);

          case title2:
            value = getFontSize(SizeConstants.largeText);

          case dialogTitle:
            value = getFontSize(SizeConstants.dialogText);

          case subTitle:
            value = getFontSize(SizeConstants.mediumText);

          case body:
            value = getFontSize(SizeConstants.extraLargeText);

          case button:
            value = getFontSize(SizeConstants.extraMediumText);

          case appBarTitle:
            value = getFontSize(SizeConstants.appBarTitleLarge + 3);

          case gridListTitle:
            value = getFontSize(SizeConstants.largeText - 5);

          case manCatFont:
            value = getFontSize(SizeConstants.extraLargeText + 20);

          case extraSmallHint:
            value = getFontSize(SizeConstants.extraLargeText);

          case smallHint:
            value = getFontSize(SizeConstants.extraLargeText + 10);

          case dialogButtonText:
            value = getFontSize(SizeConstants.extraMediumText);

          case tableHeaderText:
            value = getFontSize(SizeConstants.extraMediumText);

          case tableRowText:
            value = getFontSize(SizeConstants.mediumText);

          default:
            value = getFontSize(SizeConstants.smallText);
        }
      }
    } //mobile
    else {
      if (DeviceOrientation.isPortrait) {
        //for portrait tablet
        switch (type) {
          case title:
            value = getFontSize(SizeConstants.largeText);

          case title2:
            value = getFontSize(SizeConstants.mediumText + 5);

          case dialogTitle:
            value = getFontSize(SizeConstants.dialogText);

          case subTitle:
            value = getFontSize(SizeConstants.mediumText);

          case body:
            value = getFontSize(SizeConstants.mediumText);

          case hint:
            value = getFontSize(SizeConstants.smallText);

          case button:
            value = getFontSize(SizeConstants.extraMediumText);

          case appBarTitle:
            value = getFontSize(SizeConstants.appBarTitleLarge + 3);

          case gridListTitle:
            value = getFontSize(SizeConstants.mediumText + 3);

          case manCatFont:
            value = getFontSize(SizeConstants.extraMediumText);

          case extraSmallHint:
            value = getFontSize(SizeConstants.mediumText + 2);

          case smallHint:
            value = getFontSize(SizeConstants.mediumText + 6);

          case dialogButtonText:
            value = getFontSize(SizeConstants.mediumText);

          case tableHeaderText:
            value = getFontSize(SizeConstants.extraMediumText);

          case tableRowText:
            value = getFontSize(SizeConstants.mediumText);

          default:
            value = getFontSize(SizeConstants.extraSmallText);
        }
      } else {
        //for landscape tablet
        switch (type) {
          case title:
            value = getFontSize(SizeConstants.extraLargeText);

          case title2:
            value = getFontSize(SizeConstants.mediumText);

          case dialogTitle:
            value = getFontSize(SizeConstants.dialogText);

          case subTitle:
            value = getFontSize(SizeConstants.extraMediumText);

          case body:
            value = getFontSize(SizeConstants.extraMediumText);

          case button:
            value = getFontSize(SizeConstants.extraMediumText);

          case appBarTitle:
            value = getFontSize(SizeConstants.appBarTitleExtraLarge);

          case gridListTitle:
            value = getFontSize(SizeConstants.largeText);

          case manCatFont:
            value = getFontSize(SizeConstants.extraMediumText);

          case extraSmallHint:
            value = getFontSize(SizeConstants.mediumText + 2);

          case smallHint:
            value = getFontSize(SizeConstants.mediumText + 6);

          case dialogButtonText:
            value = getFontSize(SizeConstants.mediumText);

          case tableHeaderText:
            value = getFontSize(SizeConstants.extraMediumText);

          case tableRowText:
            value = getFontSize(SizeConstants.mediumText);

          default:
            value = getFontSize(SizeConstants.smallText);
        }
      }
    } //tablet

    return value;
  }

  ///Type is required. [type]'s are SizeConstants.[customIcon] : 44.0 px, SizeConstants.[extraLargeIcon] : 40.0 px,
  ///SizeConstants.[largeIcon] : 32.0 px, SizeConstants.[mediumIcon] : 24.0 px, SizeConstants.[smallIcon] : 16.0 px
  ///Default : 12.0 px
  ///type = large_icon,medium_icon,small_icon,extra_large_icon
  static double iconSizes({required String type}) {
    double value = 0;

    if (DeviceType.isMobile) {
      if (DeviceOrientation.isPortrait) {
        //for portrait mobile
        switch (type) {
          case customIcon:
            value = 44.0;

          case extraLargeIcon:
            value = 40.0;

          case largeIcon:
            value = 32.0;

          case mediumIcon:
            value = 24.0;

          case smallIcon:
            value = 16.0;

          default:
            value = 12.0;
        }
      } else {
        //for landscape mobile
        switch (type) {
          case customIcon:
            value = 44.0;

          case extraLargeIcon:
            value = 40.0;

          case largeIcon:
            value = 32.0;

          case mediumIcon:
            value = 24.0;

          case smallIcon:
            value = 16.0;

          default:
            value = 12.0;
        }
      }
    } //mobile
    else {
      if (DeviceOrientation.isPortrait) {
        //for portrait tablet
        switch (type) {
          case customIcon:
            value = 44.0;

          case extraLargeIcon:
            value = 40.0;

          case largeIcon:
            value = 32.0;

          case mediumIcon:
            value = 24.0;

          case smallIcon:
            value = 16.0;

          default:
            value = 12.0;
        }
      } else {
        //for landscape tablet
        switch (type) {
          case customIcon:
            value = 44.0;

          case extraLargeIcon:
            value = 40.0;

          case largeIcon:
            value = 32.0;

          case mediumIcon:
            value = 24.0;

          case smallIcon:
            value = 16.0;

          default:
            value = 12.0;
        }
      }
    } //tablet

    return value;
  }
}
