import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bills extends StatefulWidget {
  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  final user = FirebaseAuth.instance.currentUser;
  late final userEmail = user?.email;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late List _fields;
  void initState() {
    super.initState();
    _fields = [
      Row(children: [
        TextField(
          controller: _pidController,
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
          decoration: InputDecoration(labelText: 'Total Price'),
        ),
      ])
    ];
  }

  void _addNewField() {
    setState(() {
      _fields.add(Row(children: [
        TextField(
          controller: _pidController,
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
          decoration: InputDecoration(labelText: 'Total Price'),
        ),
      ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Bill'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ..._fields,
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addNewField,
              child: Text('Add Row'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            addBill(userEmail!);
          },
          child: Text('Create Bill'),
        ),
      ],
    );
  }

  Future<void> addBill(String userEmail) async {
    await firestore.collection('bills').add({
      'name_quantity[]': _pidController.text,
      'name_quantity': _nameController.text,
      'user_email': userEmail,
    });
    setState(() {
      _pidController.text = '';
      _nameController.text = '';
      _quantityController.text = '';
      _priceController.text = '';
    });
  }
}
