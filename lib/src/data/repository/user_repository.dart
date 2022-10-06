import 'package:dio/dio.dart';

import '../api/certification/auth_api.dart';
import '../api/certification/valid_api.dart';
import '../enum/http_status.dart';
import '../model/user.dart';

class UserRepository {
  final AuthApi authApi;
  final ValidApi validApi;
  User? user;

  UserRepository({required this.authApi, required this.validApi});

  Future<HttpStatusEnum> login(
      {required String accountName, required String password}) async {
    Map<String, dynamic> data = {
      'accountName': accountName,
      'password': password
    };

    final Response? response = await authApi.login(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return HttpStatusEnum.Unknown;
    }

    try {
      user = User.fromJson(response.data);
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }

  Future<Map<String, dynamic>> signUp(
      {required String accountName,
      required String password,
      required String nickname,
      required String email,
      required String walletAddress}) async {
    Map<String, dynamic> data = {
      'accountName': accountName,
      'password': password,
      'nickname': nickname,
      'email': email,
      'walletAddress': walletAddress
    };

    final Response? response = await authApi.signUp(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return {'message': HttpStatusEnum.Unknown.message, 'data': null};
    }

    return {
      'message': HttpStatusEnum.getByCode(response.statusCode!).message,
      'data': response.data
    };
  }
}
