// import 'package:http/http.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:web_socket_channel/io.dart';
//
// class Web3ApiClient {
//   static final _rpcUrl =
//       "https://ropsten.infura.io/v3/${dotenv.env['INFURA_API_KEY']!}";
//   static final _wsUrl =
//       "ws://ropsten.infura.io/v3/${dotenv.env['INFURA_API_KEY']!}";
//
//   final Web3Client _ethClient =
//       Web3Client(_rpcUrl, Client(), socketConnector: () {
//     return IOWebSocketChannel.connect(_wsUrl).cast<String>();
//   });
//   late Credentials _credentials;
//   late EthereumAddress _ownAddress;
//
//   Future<void> init() async {
//     await getCredentials();
//     final token =  Token(address: contractAddr, client: client);
//   }
//
//   Future<void> getCredentials() async {
//     // TODO: API connect
//     await Future.delayed(const Duration(seconds: 1));
//     _credentials = EthPrivateKey.fromHex(dotenv.env['PRIVATE_KEY']!);
//     _ownAddress = await _credentials.extractAddress();
//   }
// }
