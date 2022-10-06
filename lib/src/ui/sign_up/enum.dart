enum SignUpFormFieldEnum {
  accountName('accountName'),
  password('password'),
  nickname('nickname'),
  email('email'),
  walletAddress('walletAddress'),
  unknown('unknown');

  final String fieldName;

  const SignUpFormFieldEnum(this.fieldName);

  factory SignUpFormFieldEnum.getByFieldName(String fieldName) =>
      SignUpFormFieldEnum.values.firstWhere(
          (value) => value.fieldName == fieldName,
          orElse: () => SignUpFormFieldEnum.unknown);
}
