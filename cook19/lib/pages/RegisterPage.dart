import 'package:cook19/services/auth.dart';
import 'package:cook19/services/database.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage();
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var name = '';
  var email = '';
  var password = '';
  bool isLoading = false;
  DBService db = DBService.instance;
  AuthService auth = AuthService.instance;

  updateLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  showSnackBar(String msg, BuildContext context) {
    Scaffold.of(context)
      // ignore: deprecated_member_use
      ..removeCurrentSnackBar()
      // ignore: deprecated_member_use
      ..showSnackBar(SnackBar(
        content: Text('$msg'),
      ));
  }

  void onRegister(BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      updateLoading();
      try {
        await auth.registerWithEmail(email, password, name);
        //pushes the homepage
        Navigator.of(context)
          ..pop()
          ..pushReplacementNamed('/');
      } catch (e) {
        showSnackBar(e.message, context);
        updateLoading();
      }
    } else {
      showSnackBar('All fields are required.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: Builder(
            builder: (context) => ListView(
              padding: const EdgeInsets.all(30),
              children: <Widget>[
                const Text(
                  'New Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Name', prefixIcon: Icon(Icons.account_circle)),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Email', prefixIcon: Icon(Icons.email)),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                                TextField(
                  decoration: InputDecoration(
                      hintText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  child: RaisedButton(
                    child: Text('Register'),
                    color: Theme.of(context).primaryColor,
                    onPressed: isLoading ? null : () => onRegister(context),
                  ),
                  height: 35,
                ),
                const SizedBox(height: 60),
                FlatButton(
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  highlightColor: Colors.amber[100],
                  splashColor: Colors.amber[50],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
