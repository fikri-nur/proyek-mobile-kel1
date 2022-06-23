import 'package:flutter/material.dart';
import 'package:proyek_uts_flutter/authentikasi/choose_login.dart';
import 'package:proyek_uts_flutter/authentikasi/sign_in.dart';
import 'package:proyek_uts_flutter/pages/home.dart';
import 'package:proyek_uts_flutter/pages/inputnama.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigationbar extends StatefulWidget {
  const Navigationbar({Key? key}) : super(key: key);

  @override
  _NavigationbarState createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Inputnama(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5DB075),
        centerTitle: true,
        title: const Text("HuTangmu", style: TextStyle(fontFamily: 'inter')),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => logOut(),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt),
            label: 'Input Nama',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5DB075),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  logOut() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut().then((_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (contex) => const ChooseLogin())));
    }
    signOutGoogle();
  }
}
