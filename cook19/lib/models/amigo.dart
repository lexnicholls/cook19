import 'package:cloud_firestore/cloud_firestore.dart';

class Amigo {
  final String image;
  final String name;
  final String number;
  final String uid;
  Amigo({this.image, this.name, this.number, this.uid});
  factory Amigo.fromSnapshot(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data;
    return Amigo(
        uid: ds.documentID,
        image: data["image"],
        name: data["name"],
        number: data["number"]);
  }
}
