import 'package:cook19/pages/contacto/chat.dart';
import 'package:cook19/models/DeimosDialogflowApp.dart';
import 'package:flutter/material.dart';

class AmigoPage extends StatefulWidget {
  const AmigoPage();
  @override
  AmigoPageState createState() =>AmigoPageState();
}

class AmigoPageState extends State<AmigoPage> {
  int _currentIndex = 0;

  List<Widget> pages = [
    ChatPage() 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         //actions: [
           // IconButton(
             // icon: Icon(Icons.help_sharp),
             // onPressed: () {
              //  Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => DeimosDialogflowApp()),
            //);
                
            //  },
             // )
        //],
        title: Text("Chats"),
      ),
      body: pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            
            //Navigator.of(context).pushReplacementNamed('/listaAmigo');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeimosDialogflowApp()),
            );

          },
          child: Icon(Icons.help_sharp),)
    );
  }
}
