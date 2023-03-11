import 'package:apple_bhe/data/tables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderScreen extends StatefulWidget {
  static const String id = 'order_screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: TableWithAddButton(),
      );
}
