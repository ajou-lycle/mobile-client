import 'package:dio/dio.dart';

import '../../api/certification/valid_api.dart';
import '../../enum/http_status.dart';
import '../../model/valid.dart';

class ValidRepository {
  final ValidApi validApi;
  final Valid valid = Valid();

  ValidRepository({required this.validApi});

  Future<HttpStatusEnum> accountNameExists(
      String accountName, int index) async {
    Map<String, dynamic> data = {'accountName': accountName};

    final Response? response = await validApi.accountNameExists(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return HttpStatusEnum.Unknown;
    }

    try {
      valid.isPassList[index] = !response.data['result'];
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }

  Future<HttpStatusEnum> nicknameExists(String nickname, int index) async {
    Map<String, dynamic> data = {'nickname': nickname};

    final Response? response = await validApi.nicknameExists(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return HttpStatusEnum.Unknown;
    }

    try {
      valid.isPassList[index] = !response.data['result'];
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }

  Future<HttpStatusEnum> walletAddressExists(
      String walletAddress, int index) async {
    Map<String, dynamic> data = {'walletAddress': walletAddress};

    final Response? response = await validApi.walletAddressExists(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return HttpStatusEnum.Unknown;
    }

    try {
      valid.isPassList[index] = !response.data['result'];
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }

  Future<HttpStatusEnum> emailSend(String email, int index) async {
    Map<String, dynamic> data = {'email': email};

    final Response? response = await validApi.emailSend(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return HttpStatusEnum.Unknown;
    }

    try {
      valid.isPassList[index] = response.data['result'];
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }

  Future<HttpStatusEnum> emailCheck(String email, int index) async {
    Map<String, dynamic> data = {'email': email};

    final Response? response = await validApi.emailCheck(data);

    if (response == null) {
      // TODO: Application error, application restart.
      return HttpStatusEnum.Unknown;
    }

    print(response);

    try {
      valid.isPassList[index] = response.data['result'];
    } catch (e) {
      print(e);
    }

    return HttpStatusEnum.getByCode(response.statusCode!);
  }
}
