import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cook19/pages/Recipes.dart';
import 'package:cook19/pages/Profile.dart';
import 'package:cook19/pages/contacto/amigo.dart';
import 'package:cook19/pages/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MainView.dart';
import 'Recipes.dart';
import 'Profile.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  int _currentPage = 2;
  PageController _pageController = new PageController();
  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        currentUser = user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }


  @override
  Widget build(BuildContext context) {
  List<Widget> _pages = [MainView(), Recipes(), AmigoPage(), Profile()];
    return Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: _pages,
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          currentIndex: _currentPage,
          onItemSelected: (index) => setState(() {
            _currentPage = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Inicio'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.menu_book),
                title: Text('Recetas'),
                activeColor: Colors.pink),
            BottomNavyBarItem(
                icon: Icon(Icons.people),
                title: Text('Chat'),
                activeColor: Colors.green),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Perfil'),
                activeColor: Colors.purpleAccent),
          ],
        ));
  }
}
