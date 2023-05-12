import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart' as prov;
import 'package:apple_bhe/link_contract.dart';
import 'package:apple_bhe/block.dart';

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
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _pnameController = TextEditingController();
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
          controller: _pnameController,
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
      _fields.add(
        Row(
          children: [
            Flexible(
              child: TextField(
                controller: _pidController,
                decoration: InputDecoration(labelText: 'ID'),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _pnameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
            ),
            Flexible(
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Total Price'),
              ),
            ),
          ],
        ),
      );
    });
  }

  String? selectedDocId;
  late LinkSmartContract linkSmartContract;
  late List<Block> blocks;

  handleCreateBlock() async {
    Block block = new Block(
      orderId: _idController.text,
      orderName: _nameController.text,
      billType: _typeController.text,
      value: _valueController.text,
      created: new DateTime.now(),
    );
    await linkSmartContract.addBlock(block);
  }

  @override
  Widget build(BuildContext context) {
    linkSmartContract =
        prov.Provider.of<LinkSmartContract>(context, listen: true);
    blocks = linkSmartContract.blocks;
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
            linkSmartContract.isLoading;
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
                      child: Text('Create Bill'),
                      onPressed: () {
                        addRow(userEmail);
                        Navigator.of(context).pop();
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //         title: Text('Create Bill'),
                        //         content: SingleChildScrollView(
                        //           child: Column(
                        //             children: [
                        //               ..._fields,
                        //               SizedBox(height: 10),
                        //               ElevatedButton(
                        //                 onPressed: _addNewField,
                        //                 child: Text('Add Row'),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         actions: [
                        //           TextButton(
                        //             onPressed: () {
                        //               addBill(userEmail);
                        //             },
                        //             child: Text('Create Bill'),
                        //           ),
                        //           TextButton(
                        //             onPressed: () {
                        //               Navigator.of(context).pop();
                        //             },
                        //             child: Text('Cancel'),
                        //           )
                        //         ]);
                        //   },
                        // );
                      },
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
    handleCreateBlock();
    setState(() {
      _idController.text = '';
      _nameController.text = '';
      _typeController.text = '';
      _valueController.text = '';
    });
  }

  Future<void> addBill(String userEmail) async {
  final collectionReference =
      FirebaseFirestore.instance.collection('bills');
  List<Map<String, dynamic>> rowData = [];
  // Modify the data in the array
  for (var row in _fields) {
    Map<String, dynamic> rowMap = {
      'id': (_pidController.text),
      'name': (_pnameController.text),
      'quantity': (_quantityController.text),
      'total_price': (_priceController.text),
    };
    rowData.add(rowMap);
  }
    final inventoryQuerySnapshot = await firestore
        .collection('inventory')
        .where('id', isEqualTo: _pidController.text)
        .limit(1)
        .get();
    if (inventoryQuerySnapshot.docs.isNotEmpty) {
      final inventoryData = inventoryQuerySnapshot.docs[0].data();
      final String name = inventoryData['name'];
      final String price = inventoryData['price'];

      rowData.add({
        'id': _pidController.text,
        'name': name,
        'quantity': _quantityController.text,
        'total_price': int.parse(price) * int.parse(_quantityController.text),
      });
    }
    await collectionReference.add({'rows': rowData});
    setState(() {
      _pidController.text = '';
      _nameController.text = '';
      _quantityController.text = '';
      _priceController.text = '';
    });
  }
}