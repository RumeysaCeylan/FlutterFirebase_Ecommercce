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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Submit to your informations ",
                  style: TextStyle(fontSize: 22.0, color: Colors.lightGreen),
                ),

                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "enter your name"),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _lastnameController,
                  decoration: InputDecoration(hintText: "enter your lastname"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  decoration:
                      InputDecoration(hintText: "enter your phone number"),
                ),

                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "date of birth",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDateFromPicker(context);
                      },
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.people),
                    hintText: "choose your gender",
                    prefixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  decoration: InputDecoration(hintText: "enter your age"),
                ),

                SizedBox(
                  height: 50,
                ),

                // elevated button
                SizedBox(
                  width: 500,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      sendUserDataToDB();
                    },
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  Future sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("user-data");
    return await _collectionRef
        .doc(currentUser!.email)
        .set({
          "firstName": _nameController.text,
          "lastName": _lastnameController.text,
          "phone": _phoneController.text,
          "birthdate": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => print("user data added"))
        .catchError((dynamic error) => print(error));
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