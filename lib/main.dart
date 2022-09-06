// @dart=2.9
import 'package:flutter/material.dart';
import 'package:project1/Screens/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await GetStorage.init();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
    );
  }
}
//1//09D1kDigq0TfXCgYIARAAGAkSNwF-L9IrH_8fJAYd69HDpHCTk6V814qqcr6e-m_MxtMnqBgmihZ8MQBpos5j4ZKQBBwFgUAjtBY      
