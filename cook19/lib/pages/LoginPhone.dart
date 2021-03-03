import 'package:cook19/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone();
  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  var phone = '';
  var otp = '';
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

  final _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  // ignore: unused_field
  FirebaseUser _firebaseUser;

  AuthCredential _phoneAuthCredential;
  String _verificationId;

  void _handleError(e) {
    print(e.message);
    setState(() {
    });
  }

  Future<void> _submitPhoneNumber() async {
    String phoneNumber = "+57 " + _phoneController.text.toString().trim();
    print(phoneNumber);

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(AuthException error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      print(code.toString());
      setState(() {
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void _submitOTP() {
    String smsCode = _otpController.text.toString().trim();
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode);
    _login();
  }

  Future<void> _login() async {
    try {
      if (this._phoneAuthCredential != null &&
          this._phoneNumberController != null) {
        var authRes = await FirebaseAuth.instance
            .signInWithCredential(this._phoneAuthCredential);
        _firebaseUser = authRes.user;
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login w/ Phone'),
      ),
      body: Builder(
          builder: (context) => Center(
                child: ListView(
                  padding: EdgeInsets.all(30),
                  children: <Widget>[
                    Text(
                      'Login with your phone number!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      onChanged: (value) {
                        setState(() {
                          phone = value;
                        });
                      },
                      controller: _phoneController,
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: RaisedButton(
                        child: Text('Submit'),
                        color: Theme.of(context).primaryColor,
                        onPressed: _submitPhoneNumber,
                      ),
                      height: 35,
                      padding: EdgeInsets.symmetric(horizontal: 100),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'OTP',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                      controller: _otpController,
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: RaisedButton(
                        child: Text('Log in'),
                        color: Theme.of(context).primaryColor,
                        onPressed: _submitOTP,
                      ),
                      height: 35,
                    ),
                    SizedBox(height: 60),
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
