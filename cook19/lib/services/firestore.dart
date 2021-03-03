import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook19/models/RecipeModel.dart';
import 'package:cook19/pages/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

Stream<QuerySnapshot> getRecipes() {
  return _firestore.collection("recetas").snapshots();
}

Stream<QuerySnapshot> getRecipesByUser(String userName) {
  return _firestore
      .collection("recetas")
      .where("chef", isEqualTo: userName)
      .snapshots();
}

Stream<QuerySnapshot> getChats() {
  return _firestore.collection("chat").snapshots();
}

Stream<QuerySnapshot> getFriends() {
  return _firestore.collection("amigos").snapshots();
}

Future<Recipe> getRecipe(String uid) async {
  DocumentSnapshot snapshot =
      await _firestore.collection("recetas").document(uid).get();
  return Recipe.fromSnapshot(snapshot);
}

Future<void> addLikedRecipes(Recipe recipe) async {
  var liked = await _firestore
      .collection("users")
      .document(currentUser.uid)
      .collection("liked")
      .document(recipe.uid)
      .get();
  if (liked != null) {
    await _firestore
        .collection("users")
        .document(currentUser.uid)
        .collection("liked")
        .document(recipe.uid)
        .setData({"uid": recipe.uid});
  }
}

Stream<QuerySnapshot> getLikedRecipes() {
  if (currentUser == null) {
    return Stream.empty();
  } else {
    var snapshots = _firestore
        .collection("users")
        .document(currentUser.uid)
        .collection("liked")
        .snapshots();
    return snapshots;
  }
}

Stream<QuerySnapshot> getRecipesByList(List recipes) {
  var recipesMap = recipes.map((e) => e["uid"]).toList();
  print(recipesMap);
  if (recipesMap.length == 0) {
    return Stream.empty();
  } else {
    var snapshots = _firestore
        .collection("recetas")
        //.where("uid", isEqualTo: 2)
        .where("uid", whereIn: recipesMap)
        //.where("uid", whereIn: [2,4,6,9].toList())
        .snapshots();
    return snapshots;
  }
}

// Future<Chat> getIndividualChat(String uid) async {
//   DocumentSnapshot snapshot =
//       await _firestore.collection("chats").document(uid).get();
//   return Recipe.fromSnapshot(snapshot);
// }
