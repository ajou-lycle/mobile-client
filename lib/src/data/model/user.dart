import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  String? accessToken;
  String? nickname;
  String? walletAddress;
  String? profileImg;
  DateTime? expirationDate;

  User({this.accessToken});

  User.fromJson(Map<String, dynamic> json)
      : assert(json['accessToken'] != null),
        accessToken = json['accessToken'] {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken!);

    nickname = decodedToken['nickname'];
    walletAddress = decodedToken['walletAddress'];
    profileImg = decodedToken['profileImg'];
    expirationDate = JwtDecoder.getExpirationDate(accessToken!);
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'walletAddress': walletAddress,
        'profileImg': profileImg,
        'expirationDate': expirationDate
      };

  @override
  String toString() {
    return 'nickname: $nickname, walletAddress: $walletAddress, profileImg: $profileImg, expirationDate: $expirationDate';
  }
}
