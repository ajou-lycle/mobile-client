import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:lycle/src/data/enum/ethereum_network.dart';

import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';

import '../../data/enum/contract_function.dart';

/// HTTP API & WebSocket for web3 api with infura. Currently use ropsten testnet.
class Web3ApiClient {
  static final _rpcUrl =
      "https://ropsten.infura.io/v3/${dotenv.env['INFURA_API_KEY']!}";
  static final _wsUrl =
      "wss://ropsten.infura.io/ws/v3/${dotenv.env['INFURA_API_KEY']!}";

  // TODO: update to LYCLE Token
  static const _contractName = "StarDucksCappucinoToken";

  final Web3Client _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(_wsUrl).cast<String>();
  });

  var _abi;
  Credentials? _credentials;
  EthereumAddress? _ownAddress;
  EthereumAddress? _contractAddress;
  DeployedContract? _contract;
  final List<ContractFunction?> _contractFunctions =
      List<ContractFunction?>.empty(growable: true);

  String _transactionHash = "";
  bool _isTransactionFinished = false;

  bool get isTransactionFinished => _isTransactionFinished;

  Future<void> init() async {
    await getCredentials();
    await getAbi();
    await getDeployedContract();
  }

  /// Get owner wallet.
  ///
  /// Throws an [AssertionError] if the [privateKey] is *not* 64 64 random hex characters or
  /// this [_ownAddress] is null.
  Future<void> getCredentials() async {
    // TODO: connect API for getting owner private key from server.
    await Future.delayed(const Duration(seconds: 1));

    // TODO: 64 길이의 16 진수인지 체크하는 함수
    assert(dotenv.env['PRIVATE_KEY']!.length == 64,
        AssertionError("The private key is 64 random hex characters."));

    _credentials = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
    _ownAddress = await _credentials?.extractAddress();

    assert(
        _ownAddress != null, AssertionError("The private key must be correct"));
  }

  /// Get abi.
  ///
  /// Throws an [AssertionError] if this [_abi] is null or
  /// this [_contractAddress] is null.
  Future<void> getAbi() async {
    // TODO: connect API for getting contract abi json from server.
    String abiStringFile =
        await rootBundle.loadString("abis/$_contractName.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abi = jsonAbi['abi'];

    assert(
        _abi != "",
        AssertionError(
            "abi is empty; abi.json don't exists or wrong bundle path."));

    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]
        [EthereumNetworkType.ropstenTestnet.networkId.toString()]["address"]);

    assert(
        _contractAddress != null,
        AssertionError(
            "_contractAddress is null; Can't find address from abi.json."));
  }

  /// Get deployed contract after get abi. You must call this function after getAbi() succeed.
  ///
  /// Throws [AssertionError] if this [_abi] is null or this [_contractAddress] is null
  /// or the contract function of this [_contractFunctions] is null.
  Future<void> getDeployedContract() async {
    assert(_abi != null,
        AssertionError("_abi is null or empty. You must get abi."));
    assert(
        _contractAddress != null,
        AssertionError(
            "_contractAddress is null. You must get contract address from abi."));

    _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(_abi), _contractName),
        _contractAddress!);

    assert(_contract != null,
        "_contract is null. You must check this _abi, this _contractName and this _contractAddress.");

    _contractFunctions.add(_contract?.function("mint"));
    _contractFunctions.add(_contract?.function("burn"));
    _contractFunctions.add(_contract?.function("balanceOf"));

    for (int index = 0; index < _contractFunctions.length; index++) {
      assert(_contractFunctions[index] != null,
          "${ContractFunctionEnum.getByIndex(index)} can't find. Check ${ContractFunctionEnum.getByIndex(index)} exist in deployed contract");
    }
  }

  /// Mint token.
  ///
  /// Throws [AssertionError] if this [_contract] is null or mint function is null.
  Future<void> mint(EthereumAddress to, BigInt amount) async {
    assert(_contract != null,
        "_contract is null; You must get deployed contract.");
    assert(_contractFunctions[ContractFunctionEnum.mint.index] != null,
        "${_contractFunctions[ContractFunctionEnum.mint.index]} is null; You must get function, mint.");

    print("before: ${await balanceOf(to)}");

    Transaction transaction = Transaction.callContract(
      contract: _contract!,
      function: _contractFunctions[ContractFunctionEnum.mint.index]!,
      parameters: [to, amount],
      maxGas: 10000000,
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 25),
      from: _ownAddress,
    );

    _transactionHash = await _client.sendTransaction(_credentials!, transaction,
        chainId: EthereumNetworkType.ropstenTestnet.networkId);

    final resultSocket = _client.socketConnector?.call();

    assert(resultSocket != null, "Web3Client socket connector is null");

    // test code
    resultSocket?.sink.add(
        '{"jsonrpc":"2.0","method":"eth_subscribe","params":["logs", {"address":"$_contractAddress","topics":[]}],"id":1}');
    resultSocket?.stream.listen((event) async {
      Map<String, dynamic> log = jsonDecode(event);
      bool isFinishedTransactionLog = log['params'] != null ? true : false;

      if (isFinishedTransactionLog) {
        _isTransactionFinished =
            log['params']['result']['transactionHash'] == _transactionHash
                ? true
                : false;
        if (_isTransactionFinished) {
          print(await balanceOf(to));
          await resultSocket?.sink.close();
        }
      }
    });
  }

  /// Burn token.
  ///
  /// Throws [AssertionError] if this [_contract] is null or burn function is null.
  Future<void> burn(EthereumAddress to, BigInt amount) async {
    assert(_contract != null,
        "_contract is null; You must get deployed contract.");
    assert(_contractFunctions[ContractFunctionEnum.burn.index] != null,
        "${_contractFunctions[ContractFunctionEnum.burn.index]} is null; You must get function, burn.");

    print("before: ${await balanceOf(to)}");

    Transaction transaction = Transaction.callContract(
      contract: _contract!,
      function: _contractFunctions[ContractFunctionEnum.burn.index]!,
      parameters: [to, amount],
      maxGas: 10000000,
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 25),
      from: _ownAddress,
      // value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
    );

    _transactionHash = await _client.sendTransaction(_credentials!, transaction,
        chainId: EthereumNetworkType.ropstenTestnet.networkId);

    final resultSocket = _client.socketConnector?.call();

    assert(resultSocket != null, "Web3Client socket connector is null");

    // test
    resultSocket?.sink.add(
        '{"jsonrpc":"2.0","method":"eth_subscribe","params":["logs", {"address":"$_contractAddress","topics":[]}],"id":1}');
    resultSocket?.stream.listen((event) async {
      Map<String, dynamic> log = jsonDecode(event);
      bool isFinishedTransactionLog = log['params'] != null ? true : false;

      if (isFinishedTransactionLog) {
        _isTransactionFinished =
            log['params']['result']['transactionHash'] == _transactionHash
                ? true
                : false;
        if (_isTransactionFinished) {
          print(await balanceOf(to));
          // TODO: fix Warning: Operand of null-aware operation '?.' has type 'StreamChannel<String>' which excludes null.
          await resultSocket?.sink.close();
        }
      }
    });
  }

  /// Get token balance of [address].
  ///
  /// Throws [AssertionError] if this [_contract] is null or balanceOf function is null.
  Future<dynamic> balanceOf(EthereumAddress address) async {
    assert(_contract != null,
        "_contract is null. You must get deployed contract.");
    assert(_contractFunctions[ContractFunctionEnum.balanceOf.index] != null,
        "${_contractFunctions[ContractFunctionEnum.balanceOf.index]} is null. You must get function, balanceOf.");
    final balanceOf = await _client.call(
        contract: _contract!,
        function: _contractFunctions[ContractFunctionEnum.balanceOf.index]!,
        params: [address]);

    return balanceOf;
  }

  void _subscribeContractTransactionWithCallback(Function() callback) {
    // _client.socketConnector이 null이 되는 경우의 수는?
    final resultSocket = _client.socketConnector?.call();

    assert(resultSocket != null, "Web3Client socket connector is null");

    resultSocket?.sink.add(
        '{"jsonrpc":"2.0","method":"eth_subscribe","params":["logs", {"address":"$_contractAddress","topics":[]}],"id":1}');
    resultSocket?.stream.listen((event) async {
      final log = json.decode(event);
      if (log['result']['transactionHash'] == _transactionHash) {
        callback();
        // TODO: fix Warning: Operand of null-aware operation '?.' has type 'StreamChannel<String>' which excludes null.
        await resultSocket?.sink.close();
      }
    });
  }
}
