import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryScreen extends StatefulWidget {
  static const String id = 'inventory_screen';
  @override
  _InventoryScreen createState() => _InventoryScreen();
}

class _InventoryScreen extends State<InventoryScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? selectedDocId;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    if (userEmail == null) {
      return Center(
        child: Text('User not signed in.'),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Inventory'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('inventory')
              .where('user_email', isEqualTo: userEmail)
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data available.'),
              );
            }
            return DataTable(
              
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Actions')),
              ],
              rows: snapshot.data!.docs.map((doc) {
                return DataRow(
                  cells: [
                    DataCell(Text(
                      doc['id'],
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(doc['name'],
                        style: TextStyle(color: Colors.white))),
                    DataCell(Text(doc['quantity'],
                        style: TextStyle(color: Colors.white))),
                    DataCell(Text(doc['price'],
                        style: TextStyle(color: Colors.white))),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                selectedDocId = doc.id;
                                _idController.text = doc['id'];
                                _nameController.text = doc['name'];
                                _quantityController.text = doc['quantity'];
                                _priceController.text = doc['price'];
                              });
                            },
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                selectedDocId = doc.id;
                              });
                              deleteRow();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff706993),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Row'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _idController,
                          decoration: InputDecoration(labelText: 'ID'),
                        ),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: _quantityController,
                          decoration: InputDecoration(labelText: 'Quantity'),
                        ),
                        TextField(
                          controller: _priceController,
                          decoration: InputDecoration(labelText: 'Price'),
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
                        addRow(userEmail);
                        Navigator.of(context).pop();
                      },
                      child: Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ));
  }

  Future<void> addRow(String userEmail) async {
    await firestore.collection('inventory').add({
      'id': _idController.text,
      'name': _nameController.text,
      'quantity': _quantityController.text,
      'price': _priceController.text,
      'user_email': userEmail,
    });
    setState(() {
      _idController.text = '';
      _nameController.text = '';
      _quantityController.text = '';
      _priceController.text = '';
    });
  }

  Future<void> editRow() async {
    await firestore.collection('inventory').doc(selectedDocId).update({
      'id': _idController.text,
      'name': _nameController.text,
      'quantity': _quantityController.text,
      'price': _priceController.text,
    });
    setState(() {
      selectedDocId = null;
      _idController.text = '';
      _nameController.text = '';
      _quantityController.text = '';
      _priceController.text = '';
    });
  }

  Future<void> deleteRow() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this row?'),
          actions: [
            TextButton(
              onPressed: () async {
                await firestore
                    .collection('inventory')
                    .doc(selectedDocId)
                    .delete();
                Navigator.of(context).pop();
                setState(() {
                  selectedDocId = null;
                  _idController.text = '';
                  _nameController.text = '';
                  _quantityController.text = '';
                  _priceController.text = '';
                });
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
