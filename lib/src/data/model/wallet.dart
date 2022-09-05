import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class UserWallet {
  EthereumAddress? address;
  EtherAmount ethereumBalance = EtherAmount.zero();
  BigInt tokenBalance = BigInt.zero;
  int nonce = 0;
}
