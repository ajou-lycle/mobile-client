enum EthereumNetworkType {
  unknownChain(0, 'Unknown Chain'),
  ethereumMainnet(1, 'Ethereum Mainnet'),
  // deprecated
  // ropstenTestnet(3, 'Ropsten Testnet'),
  // rinkebyTestnet(4, 'Rinkeby Testnet'),
  goreliTestnet(5, 'Goreli Testnet');

  final int networkId;
  final String networkName;

  const EthereumNetworkType(this.networkId, this.networkName);

  factory EthereumNetworkType.getByNetworkId(int networkId) =>
      EthereumNetworkType.values.firstWhere(
          (value) => value.networkId == networkId,
          orElse: () => EthereumNetworkType.unknownChain);
}
