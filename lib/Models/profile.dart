import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/Screens/ProfileUpdate.dart';
import 'package:project1/Screens/Welcome.dart';
import 'package:project1/Services/auth.dart';

class ProfileState extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileState> {
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _lastnameController = TextEditingController();

  TextEditingController? _phoneController = TextEditingController();
  TextEditingController? _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROFILE"),
        backgroundColor: Colors.green,
      ),
      drawer: NavigationDrawer(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              if (data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return setDataToTextField(data);
            }),
      )),
      backgroundColor: Colors.white,
    );
  }

  setDataToTextField(data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _nameController =
                TextEditingController(text: data['firstName']),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _lastnameController =
                TextEditingController(text: data['lastName']),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _phoneController =
                TextEditingController(text: data['phone']),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _ageController =
                TextEditingController(text: data['age']),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: ElevatedButton(
            onPressed: () => updateData(),
            child: Text(
              "UPDATE",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreen,
              elevation: 3,
            ),
          ),
        )
      ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("user-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "firstName": _nameController!.text,
      "lastName": _lastnameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
    }).then((value) => print("updated succesfully"));
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
