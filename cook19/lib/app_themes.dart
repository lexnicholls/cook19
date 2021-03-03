library my_prj.globals;

import 'package:flutter/material.dart';

// enum AppTheme { BrightRed, DarkAmber, BrightTeal, DarkCyan }

// /// Returns enum value name without enum class name.
// String enumName(AppTheme anyEnum) {
//   return anyEnum.toString().split('.')[1];
// }
// final appThemeData = {
//   AppTheme.BrightRed:
//       ThemeData(brightness: Brightness.light, primaryColor: Color(0xfff05454),accentColor: Color(0xffe8e8e8)),
//   AppTheme.BrightTeal:
//       ThemeData(brightness: Brightness.light, primaryColor: Color(0xffecf4f3), accentColor: Color(0xff006a71)),
//   AppTheme.DarkAmber:
//       ThemeData(brightness: Brightness.dark, primaryColor: Color(0xfff0a500), accentColor: Color(0xff1a1c20)),
//   AppTheme.DarkCyan:
//       ThemeData(brightness: Brightness.dark, primaryColor: Color(0xff00b7c2),accentColor: Color(0xff1b262c))
// };

ThemeData brightRed = new ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xfff05454),
    accentColor: Color(0xffe8e8e8));
ThemeData brightTeal = new ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xffecf4f3),
    accentColor: Color(0xff006a71));
ThemeData darkAmber = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xfff0a500),
    accentColor: Color(0xff1a1c20));
ThemeData darkCyan = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff00b7c2),
    accentColor: Color(0xff1b262c));

List<ThemeData> themes = [brightRed, brightTeal, darkAmber, darkCyan];
List<String> themesList = ["Bright Red", "Bright Teal", "Dark Amber", "Dark Cyan"];