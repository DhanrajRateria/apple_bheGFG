import 'package:flutter/material.dart';

class TableWithAddButton extends StatefulWidget {
  @override
  _TableWithAddButtonState createState() => _TableWithAddButtonState();
}

class _TableWithAddButtonState extends State<TableWithAddButton> {
  List<String> headers = ['ID', 'Party Name', 'Type', 'Bill Type', 'Value'];
  List<List<String>> rows = [];
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();

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
                    onPressed: () {
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
