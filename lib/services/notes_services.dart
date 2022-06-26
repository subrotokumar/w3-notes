import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:w3_notes/models/note.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class NotesServices extends ChangeNotifier {
  List<Note> notes = [];
  final String _rpcURL =
      Platform.isAndroid ? 'http://10:0.2.2:8545' : 'http://127.0.0.1:8545';
  final String _wsUrl =
      Platform.isAndroid ? 'http://10.0.2.2:8545' : 'ws://127.0.0.1:8545';

  bool isLoading = true;

  late Web3Client _web3client;
  final String _privateKey =
      'ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80';
  final String cAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

  NotesServices() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(
      _rpcURL,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;

  Future<void> getABI() async {
    String abiFile = await rootBundle
        .loadString('artifacts/contracts/NoteContract.sol/NoteContract.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'NoteContract');
    _contractAddress = EthereumAddress.fromHex(cAddress);
  }

  late EthPrivateKey _cred;
  Future<void> getCredentials() async {
    _cred = EthPrivateKey.fromHex(_privateKey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createNote;
  late ContractFunction _deleteNote;
  late ContractFunction _notes;
  late ContractFunction _noteCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createNote = _deployedContract.function('createNote');
    _deleteNote = _deployedContract.function('deleteNote');
    _notes = _deployedContract.function('names');
    _noteCount = _deployedContract.function('noteContract');
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    List totalTaskList = await _web3client
        .call(contract: _deployedContract, function: _noteCount, params: []);
    int totalTaskLen = totalTaskList[0].toInt();
    notes.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3client.call(
          contract: _deployedContract,
          function: _notes,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        notes.add(
          Note(
            id: (temp[0] as BigInt).toInt(),
            title: temp[1],
            description: temp[2],
          ),
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(String title, String description) async {
    await _web3client.sendTransaction(
      _cred,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createNote,
        parameters: [title, description],
      ),
    );
    isLoading = true;
    fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await _web3client.sendTransaction(
      _cred,
      Transaction.callContract(
          contract: _deployedContract,
          function: _deleteNote,
          parameters: [BigInt.from(id)]),
    );
    isLoading = true;
    notifyListeners();
    fetchNotes();
  }
}
