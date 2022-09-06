// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project1/Screens/SignUpPage.dart';
import 'package:project1/Screens/Welcome.dart';
import 'package:project1/Services/auth.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mesaj = "LOGIN";
  bool remembermeBtn = false;
  var formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  AuthService _authService = AuthService();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mesaj),
        backgroundColor: Colors.black45,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          key: formKey,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                backGroundLogin(),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30.0),
                        buildEmailLogin(),
                        SizedBox(
                          height: 30.0,
                        ),
                        buildPasswordLogin(),
                        buildForgotLogin(context),
                        buildRemembermeBtn(),
                        buildLoginBtn(context),
                        buildSignUpBtn(context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
      backgroundColor: Colors.deepOrangeAccent,
    );
  }

  Widget buildSignUpBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpState()),
        );
      },
      child: RichText(
          text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an Account?  ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }

  Widget buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25.0,
      ),
      width: double.infinity,
      child: RaisedButton(
        elevation: 10.0,
        onPressed: () => setState(() {
          _authService.login(_email.text, _password.text).then((value) {
            return Navigator.push(context,
                MaterialPageRoute(builder: (context) => WelcomeState()));
          }).catchError((dynamic error) {
            if (error.code.contains('invalid-email')) {
              Fluttertoast.showToast(msg: "INVALID MAIL");
            }
            if (error.code.contains('user-not-found')) {
              Fluttertoast.showToast(msg: "INVALID MAIL");
            }
            if (error.code.contains('wrong-password')) {
              Fluttertoast.showToast(msg: "WRONG PASSWORD");
            }
          });
        }),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.deepOrange,
            letterSpacing: 2,
            fontSize: 18.0,
            // fontWeight: FontWeight.normal,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget buildRemembermeBtn() {
    return Container(
      height: 20.0,
      child: Row(
        children: [
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: remembermeBtn,
                checkColor: Colors.blueAccent,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    remembermeBtn = value!;
                    print(value);
                  });
                },
              )),
          Text(
            'Remember Me',
            style: TextStyle(
                color: Colors.white70,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildForgotLogin(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Yeniden şifre oluştur'),
                  content: const Text('Emailinize kod gönderilecek'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                )),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password ? ',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget buildEmailLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white54,
          ),
          height: 50.0,
          child: TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.orangeAccent,
              ),
              hintText: "Email adresinizi giriniz",
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w100),
            ),
            /*validator: (value) {
              return value!.contains(
                      RegExp(r'[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}'))
                  ? null
                  : "Invalid E-mail";
            },*/
          ),
        )
      ],
    );
  }

  Widget buildPasswordLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white54,
          ),
          height: 50.0,
          child: TextField(
            controller: _password,
            obscureText: true, //****
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.orangeAccent,
              ),
              hintText: "Şifrenizi giriniz",
              hintStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w100),
            ),
            /*validator: (value) {
              return value!.length > 5
                  ? null
                  : "Password must be at least 6 characters";
            },*/
          ),
        )
      ],
    );
  }

  Widget backGroundLogin() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.deepOrangeAccent,
          Colors.white38,
          Colors.redAccent,
          Colors.red,
        ],
        stops: [0.1, 0.4, 0.7, 0.9],
      )),
    );
  }
}
