import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';

class AuthApi {
  final String _authApiUri = '${dotenv.env['SERVER_API_URI']!}/auth';
  final Dio _dio = Dio();

  Future<Response?> login(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_authApiUri/login', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> signUp(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_authApiUri/sign-up', data: data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
