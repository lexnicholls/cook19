import 'package:cook19/ThemeManager.dart';
import 'package:cook19/app_themes.dart';
import 'package:cook19/pages/HomePage.dart';
import 'package:cook19/pages/LoginPhone.dart';
import 'package:cook19/pages/LoginPage.dart';
import 'package:cook19/pages/OwnRecipes.dart';
import 'package:cook19/pages/RegisterPage.dart';
import 'package:cook19/pages/settings.dart';
import 'package:cook19/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/contacto/amigo.dart';
import 'pages/contacto/buscaramigo.dart';

import 'package:cook19/app_themes.dart' as appTheme;

class DemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return ThemeManager();
            },
          )
        ],
        child: Consumer<ThemeManager>(
          builder: (BuildContext context, ThemeManager value, Widget child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Cook 19!',
              theme: value.themeData,
              //declaring some routes to use them by name later
              // ignore: missing_return
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case "/":
                    return MaterialPageRoute(builder: (context) => HomePage());
                  case "/login":
                    return MaterialPageRoute(
                      builder: (context) => LoginPage(),
                      fullscreenDialog: true,
                    );
                  case "/phone":
                    return MaterialPageRoute(
                      builder: (context) => LoginPhone(),
                      fullscreenDialog: true,
                    );
                  case "/register":
                    return MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                      fullscreenDialog: true,
                    );
                  case "/chats":
                    return MaterialPageRoute(
                      builder: (context) => AmigoPage(),
                      fullscreenDialog: true,
                    );
                  case "/listaAmigo":
                    return MaterialPageRoute(
                      builder: (context) => BuscarAmigo(),
                      fullscreenDialog: true,
                    );
                  case "/settings":
                    return MaterialPageRoute(
                      builder: (context) => Settings(),
                      fullscreenDialog: true,
                    );
                  case "/ownRecipes":
                    return MaterialPageRoute(
                      builder: (context) => OwnRecipes(),
                      fullscreenDialog: true,
                    );
                }
              },
              home: Landing(),
            );
          },
        ));
  }
}

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.instance.currentUser,
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          return HomePage();
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: CircularProgressIndicator(),
          );
        } else {
          return LoginPage();
        }
      },
    );
  }
}
