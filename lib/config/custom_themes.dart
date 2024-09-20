import 'package:flutter/material.dart';
import 'custom_colors.dart';

class CustomThemes {
  static final ThemeData blueTheme = ThemeData(
    primaryColor: CustomColors.bluePrimary,
    scaffoldBackgroundColor: CustomColors.blueLight,
    appBarTheme: const AppBarTheme(
      color: CustomColors.bluePrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: CustomColors.blueAccent,
      unselectedItemColor: CustomColors.blueDark,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: CustomColors.bluePrimary,
      secondary: CustomColors.blueAccent,
    ),
  );

  // Thème Rouge
  static final ThemeData redTheme = ThemeData(
    primaryColor: CustomColors.redPrimary,
    scaffoldBackgroundColor: CustomColors.redLight,
    appBarTheme: const AppBarTheme(
      color: CustomColors.redPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: CustomColors.redAccent,
      unselectedItemColor: CustomColors.redDark,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: CustomColors.redPrimary,
      secondary: CustomColors.redAccent,
    ),
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: CustomColors.greenPrimary,
    scaffoldBackgroundColor: CustomColors.greenLight,
    appBarTheme: const AppBarTheme(
      color: CustomColors.greenPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: CustomColors.greenAccent,
      unselectedItemColor: CustomColors.greenDark,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: CustomColors.greenPrimary,
      secondary: CustomColors.greenAccent,
    ),
  );

  static final ThemeData yellowTheme = ThemeData(
    primaryColor: CustomColors.yellowPrimary,
    scaffoldBackgroundColor: CustomColors.yellowLight,
    appBarTheme: const AppBarTheme(
      color: CustomColors.yellowPrimary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: CustomColors.yellowAccent,
      unselectedItemColor: CustomColors.yellowDark,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: CustomColors.yellowPrimary,
      secondary: CustomColors.yellowAccent,
    ),
  );
}
