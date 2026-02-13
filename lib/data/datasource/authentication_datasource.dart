import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';
import 'package:flutter_ecommerce_project/util/auth_manager.dart';
import 'package:flutter_ecommerce_project/util/dio_provider.dart';

abstract class IAuthenticationDatasource {
  Future<void> register(
      String username, String password, String passwordConfirm);

  Future<String> login(String username, String password);
}

class AuthenticationRemote implements IAuthenticationDatasource {
  final Dio _dio = DioProvider.createDioWithoutHeader();

  @override
  Future<void> register(
      String username, String password, String passwordConfirm) async {
    try {
      final response = await _dio.post(
        'collections/users/records',
        data: {
          'username': username,
          'name': username,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
      );
      if (response.statusCode == 200) {
        login(username, password);
      }
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      var response =
          await _dio.post('collections/users/auth-with-password', data: {
        'identity': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        AuthManager.saveId(response.data?['record']['id']);
        AuthManager.saveToken(response.data?['token']);
        return response.data?['token'];
      }
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message'],
          response: ex.response);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
    return '';
  }
}
