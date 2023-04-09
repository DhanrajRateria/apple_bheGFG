import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController phoneController = TextEditingController();

class Financials extends StatefulWidget {
  static const String id = 'financials';

  @override
  State<Financials> createState() => _FinancialsState();
}

class _FinancialsState extends State<Financials> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company Info")),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'General',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: 'Financials',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.admin_panel_settings),
            icon: Icon(Icons.bookmark_border),
            label: 'Admin',
          ),
        ],
      ),
      body: [
        SafeArea(
            child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(
              radius: 50,
            ),
            Row(
              children: [
                Text("Name of your company"),
                Text(
                  nameController.text,
                  style: TextStyle(fontFamily: "Alkatra", fontSize: 30),
                ),
              ],
            ),
            Row(
              children: [
                Text("Address"),
                Text(
                  addressController.text,
                  style: TextStyle(fontFamily: "Alkatra", fontSize: 30),
                )
              ],
            ),
            Row(
              children: [
                Text("Contact no."),
                Text(
                  phoneController.text,
                  style: TextStyle(fontFamily: "Alkatra", fontSize: 30),
                ),
              ],
            )
          ]),
        ),
        ),
        Container(
          child: Center(
            child: Text("No data to display"),
          ),
        ),
        Container(
          
        )
      ][currentPageIndex],
    );
  }
}
