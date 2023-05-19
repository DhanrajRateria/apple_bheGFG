import 'package:apple_bhe/screens/information_screens/financials.dart';
import 'package:apple_bhe/screens/information_screens/inventory.dart';
import 'package:apple_bhe/screens/information_screens/ledger.dart';
import 'package:apple_bhe/screens/information_screens/location.dart';
import 'package:apple_bhe/screens/information_screens/orders.dart';
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'images/logistic.png',
                  height: 200.0,
                ),
                Text('Welcome',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              padding: EdgeInsets.all(16.0),
              children: [
                HomeButton(
                  title: "Inventory",
                  imagename: "inventory",
                  onPressed: () {
                    Navigator.pushNamed(context, InventoryScreen.id);
                  },
                ),
                HomeButton(
                  title: "Ledger",
                  imagename: "ledger",
                  onPressed: () {
                    Navigator.pushNamed(context, LedgerScreen.id);
                  },
                ),
                HomeButton(
                  title: "Orders",
                  imagename: "orders",
                  onPressed: () {
                    Navigator.pushNamed(context, OrderScreen.id);
                  },
                ),
                HomeButton(
                  title: "Track",
                  imagename: "location",
                  onPressed: () {
                    Navigator.pushNamed(context, LocationScreen.id);
                  },
                ),
                HomeButton(
                  title: "Personnel",
                  imagename: "personnel",
                  onPressed: () {
                    Navigator.pushNamed(context, Personnel.id);
                  },
                ),
                HomeButton(
                  title: "Company Info",
                  imagename: "financials",
                  onPressed: () {
                    Navigator.pushNamed(context, Financials.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
