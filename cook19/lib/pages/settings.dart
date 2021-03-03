import 'package:cook19/app_themes.dart' as appTheme;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeManager.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        title: Text("Theme Picker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: appTheme.themes.length,
          itemBuilder: (BuildContext context, int index) {
            // Get theme enum for the current item index
            final theme = appTheme.themes[index];
            return Card(
              // Style the item with corresponding theme color
              color: theme.primaryColor,
              child: ListTile(
                onTap: () {
                  // This will trigger notifyListeners and rebuild UI
                  // because of ChangeNotifierProvider in ThemeApp
                  Provider.of<ThemeManager>(context, listen: false)
                      .setTheme(theme);
                },
                title: Text(
                  appTheme.themesList[index],
                  // ignore: deprecated_member_use
                  style: theme.textTheme.body1,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
