import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook19/models/RecipeModel.dart';
import 'package:cook19/pages/Details.dart';
import 'package:cook19/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OwnRecipes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OwnRecipeState();
  }

  void superSetUserName(String username) {
    OwnRecipeState().setUserName(username);
  }
}

String recetaCallback;

class OwnRecipeState extends State<OwnRecipes> {
  FirebaseUser currentUser;
  String userName;

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
        userName = currentUser.displayName;
      });
    });
  }

  setUserName(String username) {
    this.userName = username;
  }

  void initState() {
    super.initState();
    _loadCurrentUser();
  }

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        title: Text("Mis recetas"),
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
      stream: getRecipesByUser(userName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) => _buildItem(
                Recipe.fromSnapshot(documents[index]),
                isDualView,
                documents[index].documentID),
          );
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
    print("DBCHEF:${recipe.chef} == USERNAME: $userName");
    if (recipe.chef == userName) {
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
                  ),
                ),
              ),
              //determineButtonFunction(isDualView, uid),
            ],
          )
        ],
      ));
    }
  }
}
