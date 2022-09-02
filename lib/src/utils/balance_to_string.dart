import 'package:web3dart/web3dart.dart';

const balanceDecimalPlaces = 5;
const powFinney = 15;

String ethereumBalanceToString(EtherAmount balance) =>
    (balance.getValueInUnit(EtherUnit.finney) / 1000)
        .toStringAsPrecision(balanceDecimalPlaces);

String tokenBalanceToString(BigInt balance) =>
    ((balance ~/ BigInt.from(10).pow(powFinney)).toDouble() / 1000)
        .toStringAsPrecision(balanceDecimalPlaces);
