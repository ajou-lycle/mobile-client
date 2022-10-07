enum WalletErrorEnum {
  notConnected("connect error"),
  notUpdated("update error"),
  notDisconnected("disconnected error"),
  unknown('unknown');

  final String errorMessage;

  const WalletErrorEnum(this.errorMessage);

  factory WalletErrorEnum.getByErrorMessage(String errorMessage) =>
      WalletErrorEnum.values.firstWhere(
          (value) => value.errorMessage == errorMessage,
          orElse: () => WalletErrorEnum.unknown);
}
