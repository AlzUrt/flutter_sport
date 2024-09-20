import 'package:flutter/material.dart';
import 'custom_colors.dart';

class CustomThemes {
  // Thème Bleu
  static final ThemeData blueTheme = ThemeData(
    primaryColor: CustomColors.bluePrimary,
    // accentColor: CustomColors.blueAccent,
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
    // accentColor: CustomColors.redAccent,
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

  // Thème Vert
  static final ThemeData greenTheme = ThemeData(
    primaryColor: CustomColors.greenPrimary,
    // accentColor: CustomColors.greenAccent,
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

  // Thème Jaune
  static final ThemeData yellowTheme = ThemeData(
    primaryColor: CustomColors.yellowPrimary,
    // accentColor: CustomColors.yellowAccent,
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
