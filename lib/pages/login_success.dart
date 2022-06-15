import 'package:flutter/material.dart';

class LoginSuccess extends StatefulWidget {
  const LoginSuccess({Key? key}) : super(key: key);

  @override
  _LoginSuccessState createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF5DB075),
          centerTitle: true,
          title: const Text("HuTangmu", style: TextStyle(fontFamily: 'inter')),
        ),
        body: Container(
          child: Center(
            child: Text("Login Berhasil"),
          ),
        ));
  }
}
