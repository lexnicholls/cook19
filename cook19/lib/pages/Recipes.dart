import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook19/models/RecipeModel.dart';
import 'package:cook19/pages/Details.dart';
import 'package:cook19/services/firestore.dart';
import 'package:flutter/material.dart';

class Recipes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeState();
  }
}

String recetaCallback;

class RecipeState extends State<Recipes> {
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
      appBar: AppBar(
        title: Text('Recetas'),
      ),
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
        Flexible(
          flex: 3,
          child: Detail(
            receta: recetaCallback,
            isInDualView: true,
            comesFromMain: false,
          ),
        ),
      ],
    );
  }

  Map service;
  Widget itemList(bool isDualView) {
    return StreamBuilder(
      stream: getRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => _buildItem(
                  Recipe.fromSnapshot(documents[index]), isDualView, documents[index].documentID));
        }
      },
    );
  }

  determineButtonFunction(bool isInDualView, String uid) {
    return !isInDualView
        ? IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 42,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => Detail(
                    isInDualView: false,
                    receta: uid,
                    comesFromMain: false,
                  ),
                ),
              );
            },
          )
        : IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 42,
            onPressed: () {
              setState(() {
                recetaCallback = uid;
              });
            },
          );
  }

  clearCallback() {
    recetaCallback = null;
  }

  _buildItem(Recipe recipe, bool isDualView, String uid) {
    return Container(
        child: Column(
      children: [
        Divider(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: new ListTile(
                  title: new Text(recipe.title),
                  subtitle: new Text('Creado por: ' + recipe.chef),
                ),
              ),
            ),
            determineButtonFunction(isDualView, uid),
          ],
        )
      ],
    ));
  }
}
