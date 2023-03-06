import 'package:flutter/material.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Enter your email"),
              onChanged: (value) {
                email = value;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Enter your password"),
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
            ),
            SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              child: Text(
                "Log In",
                style: TextStyle(backgroundColor: Colors.blue),
              ),
              onPressed: () {
                Navigator.pushNamed(context, HomeScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
