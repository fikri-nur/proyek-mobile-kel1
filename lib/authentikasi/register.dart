import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/authentikasi/login.dart';
import 'package:proyek_uts_flutter/pages/navigationbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5DB075),
          centerTitle: true,
          title: const Text("HuTangmu", style: TextStyle(fontFamily: 'inter')),
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                const Padding(padding: EdgeInsets.all(8)),
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
                        backgroundColor: Color(0xFF5DB075),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: signUp,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Color(0xffffffff), fontFamily: 'inter'),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Center(
                    child: RichText(
                        text: TextSpan(
                  text: 'Sudah punya akun?',
                  style:
                      TextStyle(color: Color(0xFF5DB075), fontFamily: 'inter'),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Login',
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()))),
                  ],
                )))
              ],
            )));
  }

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('user');

  Future signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((result) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Navigationbar()),
          (Route<dynamic> route) => false,
        );
      });

      final String? nama = namaController.text;
      final String? email = emailController.text;
      final String? password = passwordController.text;
      if (nama != null && email != null && password != null) {
        await _user.add({
          "userId": FirebaseAuth.instance.currentUser?.uid,
          "nama": nama,
          "email": email,
          "password": password,
          "created_at": DateTime.now(),
        });
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
