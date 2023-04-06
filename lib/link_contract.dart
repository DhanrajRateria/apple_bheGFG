import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:web_socket_channel/io.dart';
import 'block.dart';

class LinkSmartContract extends ChangeNotifier {
  /*
  Note on _rpcUrl & _wsUrl.
  To use with android emulator use:
  - Change ganache server hostname to Loopback-Pseudo Interface 1
    final String _rpcUrl = "http://192.168.0.185:7545";
    final String _wsUrl = "ws://192.168.0.185:7545/";
  To use with real device:
  - Change ganache server hostname to Wifi
  - Copy new RPC Server url here:
    final String _rpcUrl = "http://10.0.2.2:7545";
    final String _wsUrl = "ws://10.0.2.2:7545/";


    final String _rpcUrl = "http://127.0.0.1:7545";
    final String _wsUrl = "ws://127.0.0.1:7545/";
   */

  final String _rpcUrl = "http://192.168.0.185:7545";
  final String _wsUrl = "ws://192.168.0.185:7545/";
  final String _privateKey =
      "0xe2f83c920fe2eb8b9088dd48325993b4f6364f4dcf30122b8b0f9d04336b22a2";

  List<Block> blocks = [];
  late int blockCount;
  late Web3Client _client;

  late String _abiCode;

  late EthereumAddress _contractAddress;

  late Credentials _credentials;

  late DeployedContract _contract;
  late ContractFunction _blocksCount;
  late ContractFunction _blocks;
  late ContractFunction _addBlock;
  late ContractEvent _blockAddedEvent;

  late String name;
  late String id;
  late String type;
  late String value;

  //it's used to check the contract state
  bool isLoading = true;
  //it's the name from the smart contract
  String? deployedName;

  LinkSmartContract() {
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCreadentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile = await rootBundle
        .loadString("contracts/build/contracts/Blockchain.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCreadentials() async {
    _credentials = await EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Blockchain"), _contractAddress);
    _blocksCount = _contract.function("blocksCount");
    _blocks = _contract.function("blocks");
    _addBlock = _contract.function("addBlock");
    _blockAddedEvent = _contract.event("BlockAdded");
    await getBlocks();
  }

  getBlocks() async {
    List notesList = await _client
        .call(contract: _contract, function: _blocksCount, params: []);
    BigInt totalNotes = notesList[0];
    blockCount = totalNotes.toInt();
    blocks.clear();
    for (int i = 0; i < blockCount; i++) {
      var temp = await _client.call(
          contract: _contract, function: _blocks, params: [BigInt.from(i)]);
      if (temp[1] != "")
        blocks.add(
          Block(
            orderId: temp[1],
            orderName: temp[2],
            billType: temp[3],
            value: temp[4],
            created:
                DateTime.fromMillisecondsSinceEpoch(temp[5].toInt() * 1000),
          ),
        );
    }
    isLoading = false;
    notifyListeners();
  }

  addBlock(Block block) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _addBlock,
        parameters: [
          block.orderId,
          block.orderName,
          block.billType,
          block.value,
          BigInt.from(block.created.millisecondsSinceEpoch),
        ],
      ),
    );
    await getBlocks();
  }
}
