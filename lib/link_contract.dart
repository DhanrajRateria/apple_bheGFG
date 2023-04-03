import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:web_socket_channel/io.dart';

class LinkSmartContract extends ChangeNotifier {
  final String _rpcURl = "http://127.0.0.1:7545";
  final String _wsURl = "ws://127.0.0.1:7545/";
  final String _privateKey =
      "0xe2f83c920fe2eb8b9088dd48325993b4f6364f4dcf30122b8b0f9d04336b22a2";

  late Web3Client _client;

  late String _abiCode;

  late EthereumAddress _contractAddress;

  late Credentials _credentials;

  late DeployedContract _contract;

  late ContractFunction _name;
  late ContractFunction _id;
  late ContractFunction _type;
  late ContractFunction _value;
  late ContractFunction _set;

  late String name;
  late String id;
  late String type;
  late String value;

  //it's used to check the contract state
  bool isLoading = true;
  //it's the name from the smart contract
  String? deployedName;

  LinkSmartContract() {
    initialize();
  }

  initialize() async {
    // establish a connection to the Ethereum RPC node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcURl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsURl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString("assets/blockchain.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
    // print(_credentials);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Blockchain"), _contractAddress);

    // Extracting the functions, declared in contract.
    _name = _contract.function("name");
    _id = _contract.function("id");
    _type = _contract.function("type");
    _value = _contract.function("value");
    _set = _contract.function("set");
    getName();
  }

  Future<void> getName() async {
    List orderName =
        await _client.call(contract: _contract, function: _name, params: []);
    List orderId =
        await _client.call(contract: _contract, function: _id, params: []);
    List orderValue =
        await _client.call(contract: _contract, function: _value, params: []);
    List orderType =
        await _client.call(contract: _contract, function: _type, params: []);
    name = orderName[0];
    id = orderId[0].toString();
    value = orderValue[0].toString();
    type = orderType[0].toString();

    print("$name , $id");
    isLoading = false;
    notifyListeners();
  }

  Future<void> setDetails(
      String nameToSet, String id, String value, String type) async {
    // Setting the name to nameToSet(name defined by user)
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: _contract,
          function: _set,
          parameters: [nameToSet, id, value, type],
        ));
    getName();
  }
}
