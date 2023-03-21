import 'package:apple_bhe/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TableWithAddButton extends StatefulWidget {
  @override
  _TableWithAddButtonState createState() => _TableWithAddButtonState();
}

class _TableWithAddButtonState extends State<TableWithAddButton> {
  List<String> headers = ['ID', 'Party Name', 'Type', 'Bill Type', 'Value'];
  List<List<dynamic>> rows = [];

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    fetchDocuments();
  }

  void fetchDocuments() async {
    final querySnapshot = await _firestore.collection('orders').get();
    setState(() {
      rows = querySnapshot.docs
          .map((doc) => [
                doc.data()['ID'],
                doc.data()['Party Name'],
                doc.data()['Type'],
                doc.data()['Bill type'],
                doc.data()['Value'],
              ])
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: headers
                .map((header) => DataColumn(label: Text(header)))
                .toList(),
            rows: rows
                .map((row) => DataRow(
                    cells: row.map((cell) => DataCell(Text(cell))).toList()))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Row'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller1,
                      decoration: InputDecoration(
                        labelText: 'Enter ID',
                      ),
                    ),
                    TextField(
                      controller: _controller2,
                      decoration: InputDecoration(
                        labelText: 'Enter Party Name',
                      ),
                    ),
                    TextField(
                      controller: _controller3,
                      decoration: InputDecoration(
                        labelText: 'Enter type',
                      ),
                    ),
                    TextField(
                      controller: _controller4,
                      decoration: InputDecoration(
                        labelText: 'Enter bill type',
                      ),
                    ),
                    TextField(
                      controller: _controller5,
                      decoration: InputDecoration(
                        labelText: 'Enter value',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final orders =
                            await _firestore.collection('orders').add({
                          'ID': _controller1.text,
                          'Party Name': _controller2.text,
                          'Value': _controller5.text,
                          'Bill type': _controller4.text,
                          'Type': _controller3.text
                        });
                        if (orders != null) {
                          Navigator.pushNamed(context, HomeScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        rows.add([
                          _controller1.text,
                          _controller2.text,
                          _controller3.text,
                          _controller4.text,
                          _controller5.text
                        ]);
                      });
                      Navigator.of(context).pop();
                      _controller1.clear();
                      _controller2.clear();
                      _controller3.clear();
                      _controller4.clear();
                      _controller5.clear();
                    },
                    child: Text('Add'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _controller1.clear();
                      _controller2.clear();
                      _controller3.clear();
                      _controller4.clear();
                      _controller5.clear();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
