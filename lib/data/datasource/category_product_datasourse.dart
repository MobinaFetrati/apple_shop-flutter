import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class ICategoryProductDatasourse {
  Future<List<Product>> getProductByCategoryID(String categoryID);
}

class CategoryProductRemoteDatasource extends ICategoryProductDatasourse {
  final Dio _dio = locator.get();

  @override
  Future<List<Product>> getProductByCategoryID(String categoryID) async {
    try {
      Map<String, String> qParams = {'filter': 'category="$categoryID"'};

      Response<dynamic> response;

      if (categoryID == 'qnbj8d6b9lzzpn8') {
        response = await _dio.get('collections/products/records');
      } else {
        response = await _dio.get('collections/products/records',
            queryParameters: qParams);
      }

      return response.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }
}
