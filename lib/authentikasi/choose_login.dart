import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyek_uts_flutter/authentikasi/home_screen.dart';
import 'package:proyek_uts_flutter/authentikasi/sign_in.dart';
import 'package:proyek_uts_flutter/authentikasi/login.dart';
import 'package:proyek_uts_flutter/pages/login_success.dart';
import 'package:proyek_uts_flutter/pages/navigationbar.dart';

class ChooseLogin extends StatefulWidget {
  const ChooseLogin({Key? key}) : super(key: key);

  @override
  _ChooseLoginState createState() => _ChooseLoginState();
}

class _ChooseLoginState extends State<ChooseLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5DB075),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  image: DecorationImage(
                      image: AssetImage('assets/images/purse.png'),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle),
            ),
            SizedBox(
              height: 20,
            ),
            Text("HuTangmu",
                style: TextStyle(
                    fontFamily: 'inter',
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 100,
            ),
            _signInButton1(),
            SizedBox(
              height: 20,
            ),
            _signInButton2(),
          ],
        ),
      ),
    );
  }

  Widget _signInButton1() {
    return SizedBox(
      width: 225,
      height: 55,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Something went wrong ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      return const Navigationbar();
                    } else {
                      return const Login();
                    }
                  },
                );
              },
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/email.png"), height: 50),
            SizedBox(width: 10),
            Text(
              "Login With Email",
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInButton2() {
    return SizedBox(
      width: 225,
      height: 55,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: () {
          signInWithGoogle().then((result)  async {
            if (result != null) {

              final _user =
                  FirebaseFirestore.instance.collection('user').doc(email);

              final json = {
                "userId": FirebaseAuth.instance.currentUser?.uid,
                "nama": FirebaseAuth.instance.currentUser?.displayName,
                "email": FirebaseAuth.instance.currentUser?.email,
                "password": "",
                "created_at": "",
                "last_login": DateTime.now(),
              };

              await _user.set(json);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Navigationbar()),
                (Route<dynamic> route) => false,
              );
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/images/google.png"), height: 50),
            SizedBox(width: 10),
            Text(
              "Login with Google",
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
