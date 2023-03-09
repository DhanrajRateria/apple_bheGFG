import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static const String id = 'order_screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [_createDataTable()],
        ),
      );
}

DataTable _createDataTable() {
  return DataTable(columns: _createColumns(), rows: _createRows());
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(label: Text('ID')),
    DataColumn(label: Text('Party Name')),
    DataColumn(label: Text('Bill Type')),
    DataColumn(label: Text('Type')),
    DataColumn(label: Text('Value')),
  ];
}

List<DataRow> _createRows() {
  return [
    DataRow(cells: [
      DataCell(Text('#100')),
      DataCell(Text('Flutter Basics')),
      DataCell(Text('David John'))
    ]),
    DataRow(cells: [
      DataCell(Text('#101')),
      DataCell(Text('Dart Internals')),
      DataCell(Text('Alex Wick'))
    ])
  ];
}
