import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String title;
  final String chef;
  final List steps;
  final List ingredients;
  final String uid;
  Recipe({this.steps, this.ingredients, this.title, this.chef, this.uid});
  factory Recipe.fromSnapshot(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data;
    return Recipe(
        uid: ds.documentID,
        title: data["title"],
        chef: data["chef"],
        ingredients: data["ingredients"],
        steps: data["steps"]);
  }

  toFirebase() {
    return {
      "uid": uid,
      "title": title,
      "chef": chef,
      "ingredients": ingredients,
      "steps": steps
    };
  }
}
