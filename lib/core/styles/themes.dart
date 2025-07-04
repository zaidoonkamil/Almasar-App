import 'package:flutter/material.dart';

const Color primaryColor= Color(0xFF007AFF);

class ThemeService {

  final lightTheme = ThemeData(
    scaffoldBackgroundColor:  Colors.white,
    primaryColor: primaryColor,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      elevation: 1.5,
      centerTitle: true,
      backgroundColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.9),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        showUnselectedLabels: false
    ),
    buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.dark(),
        buttonColor: Colors.black87
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.black87,
      dividerColor: primaryColor,
    ),
  );
}