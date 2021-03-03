import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook19/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cook19/models/chats.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPage();
  }
}

String chatsCallback;

class _ChatPage extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    Widget content;
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      content = _singleViewLayout();
    } else {
      content = _dualViewLayout();
    }
    return Scaffold(
      body: content,
    );
  }

  Widget _singleViewLayout() {
    return itemList(false);
  }

  Widget _dualViewLayout() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Material(
            elevation: 4.0,
            child: itemList(true),
          ),
        ),
      ],
    );
  }

  Map service;
  Widget itemList(bool isDualView) {
    return StreamBuilder(
      stream: getChats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => _buildItem(
                  Chat.fromSnapshot(documents[index]),
                  isDualView,
                  documents[index].documentID));
        }
      },
    );
  }

  _buildItem(Chat chat, bool isDualView, String uid) {
    return Container(
        child: Column(
      children: [
        Divider(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: new ListTile(
                  leading: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Image.network(chat.image, fit: BoxFit.cover),
                  ),
                  title: new Text(chat.name),
                  subtitle: new Text(chat.message),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
