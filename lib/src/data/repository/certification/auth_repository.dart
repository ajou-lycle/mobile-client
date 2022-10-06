import 'package:dio/dio.dart';

import '../../api/certification/auth_api.dart';
import '../../enum/http_status.dart';
import '../../model/user.dart';

class AuthRepository {
  final AuthApi authApi;
  User? user;

  AuthRepository({required this.authApi});

  Future<Map<String, dynamic>> login(
      {required String accountName, required String password}) async {
    Map<String, dynamic> data = {
      'accountName': accountName,
      'password': password
    };

    final Response? response = await authApi.login(data);

    User? user;

    if (response == null) {
      // TODO: Application error, application restart.
      return {'message': HttpStatusEnum.Unknown.message, 'data': null};
    }

    try {
      user = User.fromJson(response.data);
    } catch (e) {
      print(e);
    }

    return {
      'message': HttpStatusEnum.getByCode(response.statusCode!).message,
      'data': user
    };
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
