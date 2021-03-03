import 'package:cook19/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cook19/app_themes.dart' as appTheme;

class ThemeManager with ChangeNotifier {
  ThemeData _themeData;

  final _kThemePreference = "theme_preference";

  ThemeManager() {
    _loadTheme();
  }

  void _loadTheme() {
    debugPrint("Entered loadTheme()");
    SharedPreferences.getInstance().then((prefs) {
      int preferredTheme = prefs.getInt(_kThemePreference) ?? 0;
      _themeData = appTheme.themes[preferredTheme];
      notifyListeners();
    });
  }

  ThemeData get themeData {
    if (_themeData == null) {
      _themeData = appTheme.themes[0];
    }
    return _themeData;
  }

  setTheme(ThemeData theme) async {
    _themeData = theme;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kThemePreference, appTheme.themes.indexOf(theme));
  }
}
