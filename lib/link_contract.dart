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

  late ContractFunction _fullName;
  late ContractFunction _setName;

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
    String abiStringFile = await rootBundle.loadString("assets/blockchain.abi");
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
        ContractAbi.fromJson(_abiCode, "SmartContract"), _contractAddress);

    // Extracting the functions, declared in contract.
    _fullName = _contract.function("FullName");
    _setName = _contract.function("setName");
    getName();
  }

  Future<void> getName() async {
    // Getting the current name declared in the smart contract.
    var currentName = await _client
        .call(contract: _contract, function: _fullName, params: []);

    deployedName = currentName[0];
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
          function: _setName,
          parameters: [nameToSet, id, value, type],
        ));
    getName();
  }
}
