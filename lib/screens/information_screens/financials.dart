import 'package:flutter/material.dart';

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
    );
  }
}
