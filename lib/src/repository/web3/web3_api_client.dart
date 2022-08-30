import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:lycle/src/data/enum/ethereum_network.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/io.dart';

class Web3ApiClient {
  static final _rpcUrl =
      "https://ropsten.infura.io/v3/${dotenv.env['INFURA_API_KEY']!}";
  static final _wsUrl =
      "ws://ropsten.infura.io/v3/${dotenv.env['INFURA_API_KEY']!}";
  static const _contractName = "StarDucksCappucinoToken";

  final Web3Client _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(_wsUrl).cast<String>();
  });

  Credentials? _credentials;
  EthereumAddress? _ownAddress;
  EthereumAddress? _contractAddress;
  DeployedContract? _contract;
  ContractFunction? _mint;

  var _abi;

  Future<void> init() async {
    await getCredentials();
    await getAbi();
    await getDeployedContract();
  }

  Future<void> getCredentials() async {
    // TODO: API connect
    await Future.delayed(const Duration(seconds: 1));
    _credentials = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
    _ownAddress = await _credentials?.extractAddress();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("abis/$_contractName.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abi = jsonAbi['abi'];
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]
        [EthereumNetworkType.ropstenTestnet.networkId.toString()]["address"]);

    assert(
        _abi != "",
        AssertionError(
            "abi is empty; abi.json don't exists or wrong bundle path."));
    assert(
        _contractAddress != null,
        AssertionError(
            "_contractAddress is null; Can't find address from abi.json."));
  }

  Future<void> getDeployedContract() async {
    assert(_abi != null,
        AssertionError("_abi is null or empty; You must get abi.r"));
    assert(
        _contractAddress != null,
        AssertionError(
            "_contractAddress is null; You must get contract address from abi."));

    _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(_abi), _contractName),
        _contractAddress!);
    _mint = _contract?.function("mint");
  }

  Future<void> mint(int amount) async {
    assert(_contract != null,
        "_contract is null; You must get deployed contract.");
    assert(_mint != null, "_mint is null; You must get function, mint.");

    await _client
        .call(contract: _contract!, function: _mint!, params: [amount]);
  }
}
