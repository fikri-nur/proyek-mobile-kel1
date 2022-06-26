import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/authentikasi/choose_login.dart';
import 'package:proyek_uts_flutter/pages/navigationbar.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  // void initState() {
  //   super.initState();
  //   startSplashScreen();
  // }

  // startSplashScreen() async {
  //   var duration = const Duration(seconds: 5);
  //   return Timer(duration, () {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (_) {
  //         return const ChooseLogin();
  //       }),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5DB075),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  image: DecorationImage(
                      image: AssetImage('assets/images/purse.png'),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("HuTangmu",
                style: TextStyle(
                    fontFamily: 'inter',
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 225,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Something went wrong ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            return const Navigationbar();
                          } else {
                            return const ChooseLogin();
                          }
                        },
                      );
                    },
                  ));
                },
                child: const Text(
                  "Mulai",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
