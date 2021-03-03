import 'package:cook19/pages/OwnRecipes.dart';
import 'package:cook19/services/auth.dart';
import 'package:cook19/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile();
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  DBService db = DBService.instance;
  AuthService auth = AuthService.instance;
  OwnRecipes or = new OwnRecipes();

  String userName;

  FirebaseUser currentUser;

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  static const _defaultPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 20);

  _textFormater(text) {
    return Padding(
      padding: _defaultPadding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  void initState() {
    super.initState();
    _loadCurrentUser();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  // ignore: unused_element
  _saveDeviceToken() async {
    // String uid = 'jeffd23';

    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(currentUser.email)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  String _displayName() {
    if (currentUser != null) {
      if (currentUser.displayName != null) {
        return currentUser.displayName;
      } else {
        return " ";
      }
    } else {
      return "no current user";
    }
  }

  String _email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "no current user";
    }
  }

  CircleAvatar _avatar() {
    if (currentUser != null) {
      return CircleAvatar(
        radius: 80,
        child: Image(
          image: NetworkImage(currentUser.photoUrl.toString()),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(
          Icons.person,
          size: 50,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isLightMode = true ;
    return Scaffold(
      appBar: AppBar(title: Text('Perfil'), actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/settings');
              },
              child: Icon(
                Icons.brightness_4,
                size: 26.0,
              ),
            ))
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: _defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _avatar(),
                SizedBox(height: 70),
                _textFormater(
                  _displayName(),
                ),
                _textFormater(_email()),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: RaisedButton(
                      child: Text('Mis recetas'),
                      onPressed: () {
                        or.superSetUserName(currentUser.displayName);
                        Navigator.of(context)
                            .pushReplacementNamed('/ownRecipes');
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: RaisedButton(
                    child: Text('Cerrar sesión'),
                    onPressed: () {
                      auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
