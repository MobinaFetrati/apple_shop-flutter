import 'package:dio/dio.dart';

class ApiExeption implements Exception {
  int? code;
  String? message;
  Response<dynamic>? response;

  ApiExeption(this.code, this.message, {this.response}) {
    if (code != 400) {
      return;
    }
    if (message == 'Failed to authenticate.') {
      message = 'نام کاربری یا رمز عبور اشتباه است';
    }
    if (message == 'Failed to create record') {
      if (response?.data['data']['username'] != null) {
        if (response?.data['data']['username']['message'] ==
            'The username is invalid or already in use.') {
          message = 'نام کاربری نامعتبر است یا قبلا ثبت شده است';
        }
      }
    }
  }
}
