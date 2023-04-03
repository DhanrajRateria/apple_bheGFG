import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';

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
  final web3 = web3dart.Web3Client('http://localhost:7545', Client());
  late final web3dart.Credentials credentials;
  late final web3dart.DeployedContract contract;
  late final web3dart.ContractFunction addOrder;
  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  @override
  void dispose() {
    web3.dispose();
    super.dispose();
  }

  Future<void> loadCredentials() async {
    final privateKey = await rootBundle.loadString('assets/private_key.txt');
    credentials = await EthPrivateKey.fromHex(privateKey.trim());

    final abi = await rootBundle.loadString('assets/blockchain.abi');
    final contractAddress = '0xabc...'; // address of your deployed contract
    contract = web3dart.DeployedContract(
      web3dart.ContractAbi.fromJson(abi, 'Blockchain'),
      web3dart.EthereumAddress.fromHex(contractAddress),
    );
    addOrder = contract.function('addOrder');
  }

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
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Value')),
                ],
                rows: snapshot.data!.docs.map((doc) {
                  return DataRow(
                    cells: [
                      DataCell(Text(doc['id'])),
                      DataCell(Text(doc['name'])),
                      DataCell(Text(doc['bill type'])),
                      DataCell(Text(doc['value'])),
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
    final transaction = web3dart.Transaction.callContract(
      contract: contract,
      function: addOrder,
      parameters: [
        Utf8Encoder().convert(_idController.text),
        Utf8Encoder().convert(_nameController.text),
        Utf8Encoder().convert(_typeController.text),
        _valueController.text,
      ],
      from: await credentials.address,
    );

    final gas = await web3.estimateGas();
    final gasPrice = await web3.getGasPrice();
    final transactionValue = web3dart.EtherAmount.zero();
    final signedTransaction = await web3.signTransaction(
      credentials, transaction
    );

    await web3.sendTransaction(credentials,signedTransaction as web3dart.Transaction);

    setState(() {
      _idController.text = '';
      _nameController.text = '';
      _typeController.text = '';
      _valueController.text = '';
    });
  }
}
