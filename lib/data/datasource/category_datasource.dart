import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';
import '../model/category.dart';

abstract class ICategoryDatasource {
  Future<List<Category>> getCategories();
}

class CategoryRemoteDatasource extends ICategoryDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Category>> getCategories() async {
    try {
      var response = await _dio.get('collections/Category/records');
      return response.data['items']
          .map<Category>((jsonObject) => Category.fromMapJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }
}
