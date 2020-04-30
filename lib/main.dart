import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  @override
  void initState() {
    // TODO: implement initState
    isSignIn = false;
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Google OAuth",
          ),
        ),
        body: isSignIn == false ? Container(
          child: FlatButton(
            onPressed: () {
             handleSignIn();
            },
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Sign in with Google',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) : Container(
          child: Center(
            child: Column(
              children: [
                Text(_user.email),
              ],
            ),
          ),
        )
      ),
    );
  }


  bool isSignIn = false;

  //What i'm gonna do here is syncyin' an OAuth2 Procedure, waiting for the callback (await) of the sign in in order to retrieve the access token.
  //Some oauth2 clients'll provide also a refresh token, in that case we'd wait for a 401 error and then make a get request to a /refreshtoken endpoint, bodyin' it
  //with refresh token in order to retrieve a new one. BTW This isn't needed nwo.
  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    AuthResult result = (await _auth.signInWithCredential(credential));
      _user = result.user;

      setState(() {
        isSignIn = true;
      });
  }

  Future<void> googleSignOut() async {
    await _auth.signOut().then((onValue) {
      setState(() {
        isSignIn = false;
      });
    });
  }
}
