import 'package:aviation_rnd/shared/constants/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  ThemeConfig._();

  static ThemeData createTheme({
    required Brightness brightness,
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color onSecondary,
    required Color error,
    required Color onError,
    required Color surface,
    required Color onSurface,
    Color? cardBackground,
    Color? divider,
    Color? disabled,
    Color? textColor,
  }) => ThemeData(
    useMaterial3: false,
    brightness: brightness,
    primaryColor: primary,
    canvasColor: surface,
    shadowColor: onSurface,
    cardColor: cardBackground,
    dividerColor: divider,
    unselectedWidgetColor: hexToColor('#DADCDD'),
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 34, fontWeight: FontWeight.bold),
      ),
      displayMedium: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      displaySmall: GoogleFonts.poppins(
        textStyle: TextStyle(color: secondary, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      headlineLarge: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 24, fontWeight: FontWeight.w600),
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w700),
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w700),
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.w700),
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 11, fontWeight: FontWeight.w500),
      ),
      bodyLarge: GoogleFonts.poppins(textStyle: TextStyle(color: onSurface, fontSize: 18)),
      bodyMedium: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 15, fontWeight: FontWeight.w400),
      ),
      bodySmall: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 11, fontWeight: FontWeight.w300),
      ),
      labelLarge: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 12, fontWeight: FontWeight.w700),
      ),
      labelSmall: GoogleFonts.poppins(
        textStyle: TextStyle(color: onSurface, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    ),
    primaryTextTheme: TextTheme(
      bodyLarge: TextStyle(color: textColor),
      displayMedium: TextStyle(color: textColor),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: primary),
      ),
    ),
    cardTheme: CardThemeData(color: cardBackground, margin: EdgeInsets.zero, clipBehavior: Clip.antiAliasWithSaveLayer),
    iconTheme: IconThemeData(color: secondary, size: 16),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabled;
        }
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabled;
        }
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabled;
        }
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return disabled;
        }
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return null;
      }),
    ),
    cupertinoOverrideTheme: CupertinoThemeData(brightness: brightness, primaryColor: primary),
  );

  static ThemeData get lightTheme => createTheme(
    brightness: Brightness.light,
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.white,
    secondary: ColorConstants.grey,
    onSecondary: ColorConstants.white,
    error: ColorConstants.red,
    onError: ColorConstants.white,
    surface: ColorConstants.background,
    onSurface: ColorConstants.black,
    cardBackground: ColorConstants.white,
    divider: ColorConstants.grey,
    disabled: ColorConstants.grey,
    textColor: ColorConstants.black,
  );

  static ThemeData get darkTheme => createTheme(
    brightness: Brightness.dark,
    primary: ColorConstants.primary,
    onPrimary: ColorConstants.white,
    secondary: ColorConstants.grey,
    onSecondary: ColorConstants.white,
    error: ColorConstants.red,
    onError: ColorConstants.white,
    surface: ColorConstants.black,
    onSurface: ColorConstants.white,
    cardBackground: Colors.grey[900],
    divider: ColorConstants.grey,
    disabled: ColorConstants.grey,
    textColor: ColorConstants.white,
  );
}
