import 'dart:async';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/credentials.dart';

import 'package:lycle/src/repository/web3/web3_api_client.dart';

import '../../data/model/wallet.dart';

class Web3Repository {
  final Web3ApiClient web3apiClient;
  UserWallet wallet = UserWallet();
  List<String> transactionHashes = List<String>.empty(growable: true);
  WalletConnect connector = WalletConnect(
      // Link to the Wallet Connect bridge
      bridge: 'https://bridge.walletconnect.org',
      // This contains optional metadata about the client
      clientMeta: const PeerMeta(
          // Name of the application
          name: 'Lycle',
          // A small description of the application
          description:
              'An app for keep health by receiving token when health quest completed',
          // Url of the website
          url: 'https://lycle.org',
          // The icon to be shown in the Metamask connection pop-up
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  Web3Repository._internal({required this.web3apiClient});

  factory Web3Repository({required Web3ApiClient web3apiClient}) =>
      Web3Repository._internal(web3apiClient: web3apiClient);

  Future<void> init() async {
    try {
      await web3apiClient.init();

      if (!connector.connected) {
        try {
          await connector.createSession(onDisplayUri: (uri) async {
            await launchUrlString(uri, mode: LaunchMode.externalApplication);
          });
        } catch (exp) {
          print(exp);
        }
      }

      wallet = await getUserWallet(
          EthereumAddress.fromHex(connector.session.accounts[0]));
    } catch (e) {
      print("WalletRepository init error : $e");
    }
  }

  Future<UserWallet> getUserWallet(EthereumAddress address) async {
    UserWallet wallet = UserWallet();

    wallet.address = address;
    wallet.ethereumBalance =
        await web3apiClient.client.getBalance(wallet.address!);
    await balanceOf(wallet);

    return wallet;
  }

  Future<Map<int, dynamic>?> mint(EthereumAddress to, BigInt amount) async {
    try {
      final transactionHash = await web3apiClient.mint(to, amount);
      transactionHashes.add(transactionHash);

      final Map<int, dynamic> result = <int, dynamic>{
        transactionHashes.indexWhere((element) => element == transactionHash):
            web3apiClient.subscribeTransactionStatusByHash(transactionHash)
      };

      return result;
    } catch (e) {
      print("Web3Repository mint error : $e");
    }
    return null;
  }

  Future<Map<int, dynamic>?> burn(EthereumAddress to, BigInt amount) async {
    try {
      final transactionHash = await web3apiClient.burn(to, amount);
      transactionHashes.add(transactionHash);

      final Map<int, dynamic> result = <int, dynamic>{
        transactionHashes.indexWhere((element) => element == transactionHash):
            web3apiClient.subscribeTransactionStatusByHash(transactionHash)
      };

      return result;
    } catch (e) {
      print("Web3Repository burn error : $e");
    }
    return null;
  }

  Future<void> balanceOf(UserWallet wallet) async {
    try {
      final List result = await web3apiClient.balanceOf(wallet.address!);

      if (result.isNotEmpty) {
        wallet.tokenBalance = result.first;
      }
    } catch (e) {
      print("Web3Repository init error : $e");
    }
  }
}
