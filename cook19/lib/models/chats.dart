import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String image;
  final String name;
  final String number;
  final String message;
  final String time;
  final String uid;
  Chat({this.image, this.name, this.number, this.message, this.time, this.uid});
  factory Chat.fromSnapshot(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data;
    return Chat(
        uid: ds.documentID,
        image: data["image"],
        name: data["name"],
        number: data["number"],
        message: data["text"],
        time: data["time"]);
  }
}
