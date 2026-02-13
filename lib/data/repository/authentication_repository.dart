import 'package:flutter_ecommerce_project/data/datasource/authentication_datasource.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthRepository {
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm);
  Future<Either<String, String>> login(String username, String password);
}

class AuthenticationRepository extends IAuthRepository {
  final IAuthenticationDatasource _datasource = locator.get();
  final SharedPreferences _sharedPref = locator.get();

  @override
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm) async {
    try {
      await _datasource.register(username, password, passwordConfirm);

      return right('ثبت نام انجام شد');
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> login(String username, String password) async {
    try {
      String token = await _datasource.login(username, password);
      if (token.isNotEmpty) {
        return right('وارد شدید');
      } else {
        return left('خطایی پیش آمده');
      }
    } on ApiExeption catch (ex) {
      return left('${ex.message}');
    }
  }
}
