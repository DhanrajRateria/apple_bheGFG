import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:provider/provider.dart' as prov;
import 'package:apple_bhe/link_contract.dart';

class OrderScreen extends StatefulWidget {
  static const String id = 'order_screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String? selectedDocId;

  Widget build(BuildContext context) {
    var contractLink = prov.Provider.of<LinkSmartContract>(context);
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    if (userEmail == null) {
      return Center(
        child: Text('User not signed in.'),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('orders')
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
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Value')),
                ],
                rows: snapshot.data!.docs.map((doc) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        doc['id'],
                        style: TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        doc['name'],
                        style: TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        doc['bill type'],
                        style: TextStyle(color: Colors.white),
                      )),
                      DataCell(Text(
                        doc['value'],
                        style: TextStyle(color: Colors.white),
                      )),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
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
                          controller: _typeController,
                          decoration: InputDecoration(labelText: 'Bill Type'),
                        ),
                        TextField(
                          controller: _valueController,
                          decoration: InputDecoration(labelText: 'Value'),
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
                        contractLink.setDetails(
                            _nameController.text,
                            _idController.text,
                            _valueController.text,
                            _typeController.text);
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
    await firestore.collection('orders').add({
      'id': _idController.text,
      'name': _nameController.text,
      'bill type': _typeController.text,
      'value': _valueController.text,
      'user_email': userEmail,
    });

    setState(() {
      _idController.text = '';
      _nameController.text = '';
      _typeController.text = '';
      _valueController.text = '';
    });
  }
}