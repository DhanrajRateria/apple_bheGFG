import 'package:apple_bhe/data/tables.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static const String id = 'order_screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: TableWithAddButton(),
      );
}
