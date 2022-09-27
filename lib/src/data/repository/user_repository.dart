import 'package:dio/dio.dart';

import '../api/user/auth_api.dart';
import '../enum/http_status.dart';
import '../model/user.dart';

class UserRepository {
  final AuthApi authApi;
  User? user;

  UserRepository({required this.authApi});

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

    print(response.data);
    try {
      user = User.fromJson(response.data);
      print(user.toString());
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }

  Future<Map<String, dynamic>> signUp(
      {required String accountName, required String password}) async {
    Map<String, dynamic> data = {
      'accountName': accountName,
      'password': password
    };

    final Response? response = await authApi.login(data);

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
