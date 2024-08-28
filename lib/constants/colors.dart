import 'package:flutter/material.dart';

class AppColors {
  // Define light theme colors
  static final Color lightBackgroundColor = Colors.grey.shade200;

  // Define dark theme colors
  static final Color darkBackgroundColor = Colors.black;

  // Get colors based on the theme mode
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundColor
        : lightBackgroundColor;
  }
}