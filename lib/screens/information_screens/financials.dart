import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

TextEditingController nameController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController phoneController = TextEditingController();
final FirebaseFirestore firestore = FirebaseFirestore.instance;
String? selectedDocId;
final user = FirebaseAuth.instance.currentUser;
final userEmail = user?.email;

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
        StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('details')
                .where('user_email', isEqualTo: userEmail)
                .snapshots(includeMetadataChanges: true),
            builder: (context, snapshot) {
              return SafeArea(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Name of your company",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              nameController.text,
                              style: TextStyle(
                                  fontFamily: "Alkatra",
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              addressController.text,
                              style: TextStyle(
                                  fontFamily: "Alkatra",
                                  fontSize: 30,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Contact no.",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              phoneController.text,
                              style: TextStyle(
                                  fontFamily: "Alkatra",
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            child: Text("Set Details"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('Set Details'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                  labelText:
                                                      'Name of the Company'),
                                            ),
                                            TextField(
                                              controller: addressController,
                                              decoration: InputDecoration(
                                                  labelText: 'Address'),
                                            ),
                                            TextField(
                                              controller: phoneController,
                                              decoration: InputDecoration(
                                                  labelText: 'Phone'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            addDetails(userEmail!);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Add'),
                                        ),
                                      ]);
                                },
                              );
                            })
                      ]),
                ),
              );
            }),
        Container(
          child: Center(
            child: Text(
              "No data to display",
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
        ),
        Container(
          child: AlertDialog(),
        )
      ][currentPageIndex],
    );
  }
}

Future<void> addDetails(String userEmail) async {
  await firestore.collection('details').add({
    'name': nameController.text,
    'address': addressController.text,
    'phone': phoneController.text,
    'user_email': userEmail,
  });
}
