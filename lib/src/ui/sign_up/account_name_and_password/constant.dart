class SignUpAccountNameAndPasswordConstant {
  static const double textFormFieldHeight = 86;
  static const double textFormFieldErrorTextHeight = 12;
  static const double submitButtonHeight = 60;
}
//
// class SignUpAccountNameAndPasswordInfo {
//   static const List<String> titles = <String>[
//     "아이디 *",
//     "비밀번호 *",
//   ];
//   static const List<String> names = <String>[
//     'accountName',
//     'password',
//     'nickname',
//     'walletAddress',
//     'email',
//   ];
//   static const List<String> errorTexts = <String>[
//     '아이디 입력은 필수입니다.',
//     '비밀번호 입력은 필수입니다.',
//     '닉네임 입력은 필수입니다.',
//     '지갑주소 입력은 필수입니다.',
//     '이메일 입력은 필수입니다.',
//   ];
//   static const List<String> hintTexts = <String>[
//     '아이디를 입력해주세요',
//     '비밀번호를 입력해주세요',
//     '닉네임을 입력해주세요',
//     '지갑 주소를 입력해주세요',
//     '이메일을 입력해주세요',
//   ];
//   static const List<bool> needValidList = <bool>[true, false, true, true, true];
//   static const List<String> validButtonTitles = <String>[
//     '중복확인',
//     '',
//     '중복확인',
//     '중복확인',
//     '중복확인'
//   ];
//   static List validators = [
//     FormBuilderValidators.compose([
//       FormBuilderValidators.match(idMatch,
//           errorText: "특수문자, 한글 제외 3자 ~ 20자"),
//       FormBuilderValidators.required(
//           errorText: errorTexts[SignUpFormFieldEnum.accountName.index])
//     ]),
//     FormBuilderValidators.compose([
//       FormBuilderValidators.match(passwordMatch,
//           errorText: '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내'),
//       FormBuilderValidators.required(
//           errorText: errorTexts[SignUpFormFieldEnum.password.index])
//     ]),
//     FormBuilderValidators.compose([
//       FormBuilderValidators.match(nicknameMatch,
//           errorText: "초성, 특수문자 제외 3자 ~ 10자"),
//       FormBuilderValidators.required(
//           errorText: errorTexts[SignUpFormFieldEnum.nickname.index])
//     ]),
//     FormBuilderValidators.compose([
//       FormBuilderValidators.match(walletAddressMatch,
//           errorText: "올바른 지갑주소가 아닙니다"),
//       FormBuilderValidators.required(
//           errorText: errorTexts[SignUpFormFieldEnum.walletAddress.index])
//     ]),
//     FormBuilderValidators.compose([
//       FormBuilderValidators.email(errorText: "올바른 이메일이 아닙니다."),
//       FormBuilderValidators.required(
//           errorText: errorTexts[SignUpFormFieldEnum.email.index])
//     ]),
//   ];
//
//   static List generateInfo() {
//     List info = List.empty(growable: true);
//
//     for (int index = 0; index < names.length; index++) {
//       info.add({
//         "title": titles[index],
//         "name": names[index],
//         "errorText": errorTexts[index],
//         "hintText": hintTexts[index],
//         "needValid": needValidList[index],
//         "validButtonTitle": validButtonTitles[index],
//         "validator": validators[index],
//         "isPassValidation": false,
//       });
//     }
//
//     return info;
//   }
// }
