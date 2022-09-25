enum HttpStatusCode {
  Continue(100, "처리 중입니다."),
  swi("burn"),
  balanceOf("balanceOf"),
  unknownMethod("unknownMethod");

  final int code;
  final String message;

  const HttpStatusCode(this.code, this.message);

  factory ContractFunctionEnum.getByIndex(int index) =>
      ContractFunctionEnum.values.firstWhere((value) => value.index == index,
          orElse: () => ContractFunctionEnum.unknownMethod);

  factory ContractFunctionEnum.getByFunctionName(String functionName) =>
      ContractFunctionEnum.values.firstWhere(
              (value) => value.functionName == functionName,
          orElse: () => ContractFunctionEnum.unknownMethod);
}
