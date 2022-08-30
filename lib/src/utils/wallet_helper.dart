import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// reference : https://dev.to/bhaskardutta/building-with-flutter-and-metamask-8h5
///
/// Helper for get ethereum MetaMask wallet
class WalletHelper {
  SessionStatus? session;

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

  Future<void> loginUsingMetamask() async {
    if (!connector.connected) {
      try {
        session = await connector.createSession(onDisplayUri: (uri) async {
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session?.accounts[0]);
        print(session?.chainId);
      } catch (exp) {
        print(exp);
      }
    }
  }

  void subscribeConnectorEvent(
      Function(Object? session) connectCallback,
      Function(Object? session) updateCallback,
      Function(Object? session) disconnectCallback) {
    connector.on('connect', connectCallback);
    connector.on('session_update', updateCallback);
    connector.on('disconnect', disconnectCallback);
  }

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }
}
