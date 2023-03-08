import 'package:apple_bhe/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:apple_bhe/home_buttons.dart';

import 'information_screens/personnel.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeButton(
                          title: "Inventory",
                          imagename: "inventory",
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                      HomeButton(
                          title: "Ledger",
                          imagename: "ledger",
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                    ]),
              ),
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeButton(
                          title: "Orders",
                          imagename: "orders",
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                      HomeButton(
                          title: "Track",
                          imagename: "location",
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                    ]),
              ),
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeButton(
                          title: "Personnel",
                          imagename: "personnel",
                          onPressed: () {
                            Navigator.pushNamed(context, Personnel.id);
                          }),
                      HomeButton(
                          title: "Company Info",
                          imagename: "financials",
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                    ]),
              )
            ]),
      ),
    );
  }
}
