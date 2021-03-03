import 'package:cook19/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = '';
  var password = '';
  bool isLoading = false;

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
        behavior: SnackBarBehavior.fixed,
      ));
  }

  Future onLogin(BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      updateLoading();
      try {
        await AuthService.instance.loginWithEmail(email, password);
        Navigator.of(context).pushReplacementNamed('/');
      } catch (e) {
        updateLoading();
        showSnackBar(e.message, context);
      }
    } else {
      showSnackBar('Email & password fields cannot be empty.', context);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  Future<void> resetPassword(String email) async {
    passwordResetSent();
    await _auth.sendPasswordResetEmail(email: email);
  }

  resetPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Enviar correo"),
                          onPressed: () {
                            resetPassword(email);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void passwordResetSent() {
    Fluttertoast.showToast(
        msg: "Correo enviado!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Builder(
          builder: (context) => Center(
                child: ListView(
                  padding: EdgeInsets.all(30),
                  children: <Widget>[
                    Text(
                      'Welcome again!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    Image(
                      image: AssetImage('assets/CookLogo.png'),
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      highlightColor: Colors.amber[100],
                      splashColor: Colors.amber[50],
                      onPressed: () {
                        resetPasswordDialog(context);
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: RaisedButton(
                        child: Text('Login'),
                        color: Theme.of(context).primaryColor,
                        onPressed: isLoading ? null : () => onLogin(context),
                      ),
                      height: 35,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "OR",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    RaisedButton.icon(
                      onPressed: () {
                        signInWithGoogle().whenComplete(() {
                          Navigator.of(context).pushReplacementNamed('/');
                        });
                      },
                      icon: Image.asset('assets/google.png', width: 20),
                      label: Text("Login with Google"),
                    ),
                    SizedBox(height: 1),
                    RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/phone');
                      },
                      icon: Image.asset('assets/phone.png', width: 20),
                      label: Text("Login with Phone"),
                    ),
                    SizedBox(height: 35),
                    Text(
                      'Don\'t have account yet?',
                      textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      highlightColor: Colors.amber[100],
                      splashColor: Colors.amber[50],
                      onPressed: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                    )
                  ],
                ),
              )),
    );
  }
}
