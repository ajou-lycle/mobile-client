enum EthereumNetworkType {
  unknownChain._internal(0, 'Unknown Chain'),
  ethereumMainnet._internal(1, 'Ethereum Mainnet'),
  ropstenTestnet._internal(3, 'Ropsten Testnet'),
  rinkebyTestnet._internal(4, 'Rinkeby Testnet'),
  goreliTestnet._internal(5, 'Goreli Testnet');

  final int networkId;
  final String networkName;

  const EthereumNetworkType._internal(this.networkId, this.networkName);

  factory EthereumNetworkType.getByNetworkId(int networkId) =>
      EthereumNetworkType.values.firstWhere(
          (value) => value.networkId == networkId,
          orElse: () => EthereumNetworkType.unknownChain);
}
