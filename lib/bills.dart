import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late List _fields;
  void initState() {
    super.initState();
    _fields = [
      Row(children: [
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
          decoration: InputDecoration(labelText: 'Total Price'),
        ),
      ])
    ];
  }

  void _addNewField() {
    setState(() {
      _fields.add(Row(children: [
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
      
    );
  }
}
