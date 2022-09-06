import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/Screens/LoginPage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:project1/Screens/ProfileUpdate.dart';
import 'package:project1/Screens/ShowListPage.dart';
import 'package:project1/Screens/Welcome.dart';
import 'package:project1/Services/TaskService.dart';
import 'package:project1/Services/auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  var formKey = GlobalKey<FormState>();
  String mesaj = "PROFILE";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mesaj),
        backgroundColor: Colors.green,
      ),
      drawer: NavigationDrawer(),
      //body: ,
      backgroundColor: Colors.white,
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  final AuthService _authService = AuthService();

  /* List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }*/

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("HOME"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WelcomeState()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("UPDATE PROFILE"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_sharp),
              title: const Text("SIGN OUT"),
              onTap: () {
                _authService.signout();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        color: Color.fromARGB(255, 28, 156, 32),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              backgroundImage: NetworkImage(
                  "https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png"),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "user" + " " + "lastname",
              style: TextStyle(fontSize: 28, color: Colors.white),
            )
          ],
        ),
      );
}
/*
    ); */