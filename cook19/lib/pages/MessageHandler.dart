import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  //cuando se agregen subscripciones
  //  FlatButton(
  //       child: Text('I like puppies'),
  //       onPressed: () => _fcm.subscribeToTopic('puppies');,
  //   ),

  //   FlatButton(
  //       child: Text('I hate puppies'),
  //       onPressed: () => _fcm.unsubscribeFromTopic('puppies');,
  //   ),

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
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
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

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
      });
    });
  }

  // ignore: unused_element
  _saveDeviceToken() async {
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
}
