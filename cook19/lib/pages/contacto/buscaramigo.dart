import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook19/models/amigo.dart';
import 'package:cook19/services/firestore.dart';
import 'package:flutter/material.dart';

import '../Details.dart';

class BuscarAmigo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuscarAmigoState();
  }
}

class BuscarAmigoState extends State<BuscarAmigo> {
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
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          title: Text("Amigos"),
        ),
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
      stream: getFriends(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => _buildItem(
                  Amigo.fromSnapshot(documents[index]),
                  isDualView,
                  documents[index].documentID));
        }
      },
    );
  }

  _buildItem(Amigo amigo, bool isDualView, String uid) {
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
                    child: Image.network(amigo.image, fit: BoxFit.cover),
                  ),
                  title: new Text(amigo.name),
                  subtitle: new Text(amigo.number),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
