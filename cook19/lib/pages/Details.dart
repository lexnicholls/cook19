import 'package:cook19/models/RecipeModel.dart';
import 'package:cook19/pages/HomePage.dart';
import 'package:cook19/pages/MainView.dart';
import 'package:cook19/pages/Recipes.dart';
import 'package:cook19/services/firestore.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  Detail({this.receta, this.isInDualView, this.comesFromMain});

  final String receta;
  final bool isInDualView;
  final bool comesFromMain;

  @override
  Widget build(BuildContext context) {
    if (receta != null) {
      return FutureBuilder(
        future: getRecipe(receta),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            Recipe recipe = snapshot.data;
            return Scaffold(
              appBar: !isInDualView
                  ? AppBar(title: Text('Detalle de la receta'))
                  : null,
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical:16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _titleFormat(recipe.title),
                    _div,
                    _titleFormat('Receta por: '),
                    _textFormat(recipe.chef),
                    _div,
                    _titleFormat('Ingredientes'),
                    ingredients(recipe),
                    _div,
                    _titleFormat('Pasos de la receta:'),
                    SizedBox(height: 10),
                    steps(recipe),
                  ],
                ),
              ),
              floatingActionButton: !comesFromMain
                  ? applyOfferFloatingButton(context, recipe, isInDualView)
                  : removeOfferFloatingButton(context, recipe, isInDualView),
            );
          }
        },
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text('Selecciona una receta del menú'),
        ),
      );
    }
  }
}

Widget applyOfferFloatingButton(context, receta, isInDualView) {
  return !isInDualView
      ? FloatingActionButton.extended(
          onPressed: () {
            MainState().pushOffer(receta);
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => HomePage()));
          },
          label: Text('Aplicar'),
          icon: Icon(Icons.check),
        )
      : FloatingActionButton.extended(
          onPressed: () {
            MainState().pushOffer(receta);
            RecipeState().clearCallback();
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => HomePage()));
          },
          label: Text('Aplicar'),
          icon: Icon(Icons.check),
        );
}

Widget removeOfferFloatingButton(context, receta, isInDualView) {
  return !isInDualView
      ? FloatingActionButton.extended(
          onPressed: () {
            MainState().removeOffer(receta);
            Navigator.pop(context);
          },
          label: Text('Eliminar'),
          icon: Icon(Icons.delete),
        )
      : FloatingActionButton.extended(
          onPressed: () {
            MainState().removeOffer(receta);
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => HomePage()));
          },
          label: Text('Eliminar'),
          icon: Icon(Icons.delete),
        );
}

Widget _div = Padding(
  child: Divider(
    height: 1,
  ),
  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 10),
);

_titleFormat(text) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 28,
    ),
  );
}

_textFormat(text) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
      fontSize: 24,
    ),
  );
}

_listFormat(text) {
  return Expanded(
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey,
      ),
      maxLines: 10,
    ),
  );
}

ingredients(receta) {
  return new ListView.builder(
    shrinkWrap: true,
    itemCount: receta.ingredients.length,
    itemBuilder: (context, i) => new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle,
            size: 20,
          ),
          SizedBox(width: 10),
          _listFormat(receta.ingredients[i]),
        ],
      ),
    ),
  );
}

steps(receta) {
  return new ListView.builder(
    shrinkWrap: true,
    itemCount: receta.steps.length,
    itemBuilder: (context, i) => new Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle,
            size: 20,
          ),
          SizedBox(width: 10),
          _listFormat(receta.steps[i]),
        ],
      ),
    ),
  );
}
