import 'package:dio/dio.dart';

class LoginApi {
  final Dio _dio = Dio();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://172.26.202.100:8090/get_auth_call',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(contentType: 'application/json'),
      );
      print(response.data);
      if (response.data == 'Login Succeesful') {
        print(response.data);
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      throw Exception('Failed to call Api: $e');
    }
  }
}
