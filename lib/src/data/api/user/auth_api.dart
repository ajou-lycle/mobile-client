import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dio/dio.dart';

class AuthApi {
  final String _authApiUri = '${dotenv.env['SERVER_API_URI']!}/auth';
  final Dio _dio = Dio();

  Future login(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('$_authApiUri/login', data: data);
      print(response);
    } catch(e) {
      print(e);
    }
  }
}
