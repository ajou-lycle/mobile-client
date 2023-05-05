import 'dart:async';

import 'package:lycle/src/data/enum/ethereum_network.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/credentials.dart';

import '../api/web3_api_client.dart';
import '../model/wallet.dart';

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
          name: 'WalletConnect',
          // A small description of the application
          description:
              'An app for keep health by receiving token when health quest completed',
          // Url of the website
          url: 'https://walletconnect.org',
          // The icon to be shown in the Metamask connection pop-up
          icons: [
            'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));
  bool isCreateSession = false;

  Web3Repository._internal({required this.web3apiClient});

  factory Web3Repository({required Web3ApiClient web3apiClient}) =>
      Web3Repository._internal(web3apiClient: web3apiClient);

  Future<void> init() async {
    try {
      await web3apiClient.init();

      if (!connector.connected) {
        if (!isCreateSession) {
          try {
            final session = await connector.createS ession(
                chainId: EthereumNetworkType.goreliTestnet.networkId,
                onDisplayUri: (uri) async {
                  await launchUrl(Uri.parse(uri),
                      mode: LaunchMode.externalApplication);
                });
          } catch (exp) {
            print("error ${exp}");
          }
          isCreateSession = true;
        } else {
          try {
            connector.session.reset();

            final session = await connector.createSession(
                chainId: 3,
                onDisplayUri: (uri) async {
                  await launchUrl(Uri.parse(uri),
                      mode: LaunchMode.externalApplication);
                });
          } catch (exp) {
            print("error ${exp}");
          }
        }
      }

      if (connector.connected && wallet.address == null) {
        wallet = await getUserWallet(
            EthereumAddress.fromHex(connector.session.accounts[0]));
      }
    } catch (e) {
      print("WalletRepository init error : $e");
    }
  }

  Future<UserWallet> getUserWallet(EthereumAddress address) async {
    UserWallet wallet = UserWallet();

    wallet.address = address;

    wallet.ethereumBalance = await web3apiClient.client.getBalance(address);

    await balanceOf(wallet);

    return wallet;
  }

  Future<Map<int, dynamic>?> mint(EthereumAddress to, BigInt amount) async {
    try {
      if (transactionHashes.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
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
      if (transactionHashes.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
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
