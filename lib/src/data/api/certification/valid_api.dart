import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';

class ValidApi {
  final String _validApiUri = '${dotenv.env['SERVER_API_URI']!}/valid';
  final Dio _dio = Dio();

  Future<Response?> accountNameExists(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_validApiUri/accountName/exists', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> nicknameExists(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_validApiUri/nickname/exists', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> walletAddressExists(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_validApiUri/walletAddress/exists', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> emailSend(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_validApiUri/email/send', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> emailConfirm(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_validApiUri/email/confirm', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> emailCheck(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_validApiUri/email/check', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
