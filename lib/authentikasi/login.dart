import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/authentikasi/register.dart';
import 'package:proyek_uts_flutter/pages/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5DB075),
          centerTitle: true,
          title: const Text("HuTangmu", style: TextStyle(fontFamily: 'inter')),
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 54, left: 20, right: 20)),
                SizedBox(
                  width: 500,
                  height: 45,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF5DB075),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: signIn,
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                          color: Color(0xffffffff), fontFamily: 'inter'),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Center(
                    child: RichText(
                        text: TextSpan(
                  text: 'Belum punya akun?',
                  style:
                      const TextStyle(color: Color(0xFF5DB075), fontFamily: 'inter'),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Register',
                        style: const TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()))),
                  ],
                )))
              ],
            )));
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Navigationbar()),
          (Route<dynamic> route) => false,
        );
      });
      
      final _user = FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser?.email);

      final json = {
        "last_login": DateTime.now(),
      };

      await _user.update(json);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
