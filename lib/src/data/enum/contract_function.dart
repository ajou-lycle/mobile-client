enum ContractFunctionEnum {
  mint("mint"),
  burn("burn"),
  balanceOf("balanceOf"),
  unknownMethod("unknownMethod");

  final String functionName;

  const ContractFunctionEnum(this.functionName);

  factory ContractFunctionEnum.getByIndex(int index) =>
      ContractFunctionEnum.values.firstWhere((value) => value.index == index,
          orElse: () => ContractFunctionEnum.unknownMethod);

  factory ContractFunctionEnum.getByFunctionName(String functionName) =>
      ContractFunctionEnum.values.firstWhere(
          (value) => value.functionName == functionName,
          orElse: () => ContractFunctionEnum.unknownMethod);
}
