import 'package:cook19/models/RecipeModel.dart';
import 'package:cook19/pages/Details.dart';
import 'package:cook19/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

List<Recipe> _recetasAceptadas = [];
Recipe recetaCallback;

class MainState extends State<MainView> {
  Widget content;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getLikedRecipes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List likedRecipes =
              snapshot.data.documents.map((e) => e.data).toList();
          var orientation = MediaQuery.of(context).orientation;
          if (orientation == Orientation.portrait) {
            content = _singleViewLayout();
          } else {
            content = _dualViewLayout();
          }
          return StreamBuilder(
            stream: getRecipesByList(likedRecipes),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _recetasAceptadas = snapshot.data.documents
                    .map((e) => Recipe.fromSnapshot(e))
                    .toList();
              }
              print(_recetasAceptadas.length);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Inicio'),
                ),
                body: content,
              );
            },
          );
        }
      },
    );
  }

  Widget _singleViewLayout() {
    return determineSingleView();
  }

  Widget _dualViewLayout() {
    return determineDualView();
  }

  determineDualView() {
    if (_recetasAceptadas.length == 0) {
      return SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 70),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Icon(
                Icons.restaurant_menu,
                size: 90,
                color: Colors.grey,
              ),
              SingleChildScrollView(
                  child: Text(
                'Aca apareceran las recetas te hayan gustado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )),
              SingleChildScrollView(
                  child: Text(
                'Para agregar una receta dirigete a la pagina de recetas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )),
            ],
          )),
        ),
      ));
    }
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
            receta: recetaCallback.uid,
            isInDualView: true,
            comesFromMain: true,
          ),
        ),
      ],
    );
  }

  determineSingleView() {
    if (_recetasAceptadas.length == 0) {
      return SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 70),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Icon(
                Icons.restaurant_menu,
                size: 90,
                color: Colors.grey,
              ),
              SingleChildScrollView(
                  child: Text(
                'Aca apareceran las recetas te hayan gustado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey,
                ),
              )),
              SingleChildScrollView(
                  child: Text(
                '\n\nPara agregar una receta dirigete a la pagina de recetas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              )),
            ],
          )),
        ),
      ));
    } else {
      return itemList(false);
    }
  }

  void pushOffer(receta) {
    addLikedRecipes(receta);
  }

  void removeOffer(receta) {
    recetaCallback = null;
    _recetasAceptadas.remove(receta);
  }

  Widget itemList(bool isDualView) {
    return new ListView.builder(
      itemCount: _recetasAceptadas.length,
      itemBuilder: (context, i) => new Column(
        children: <Widget>[
          new Divider(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: new ListTile(
                    title: new Text(_recetasAceptadas[i].title),
                    subtitle:
                        new Text('creado por: ' + _recetasAceptadas[i].chef),
                  ),
                ),
              ),
              determineButtonFunction(isDualView, i),
            ],
          )
        ],
      ),
    );
  }

  determineButtonFunction(bool isInDualView, int i) {
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
                    receta: _recetasAceptadas[i].uid,
                    comesFromMain: true,
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
                recetaCallback = _recetasAceptadas[i];
              });
            },
          );
  }
}
