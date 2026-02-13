import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class IProductDatasource {
  Future<List<Product>> getProducts();
  Future<List<Product>> getHotest();
  Future<List<Product>> getBestSeller();
}

class ProductRemoteDatasource extends IProductDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Product>> getProducts() async {
    try {
      var response = await _dio.get('collections/products/records');
      return response.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<List<Product>> getBestSeller() async {
    try {
      Map<String, String> qParams = {'filter': 'popularity="Hotest"'};

      var response = await _dio.get('collections/products/records',
          queryParameters: qParams);

      return response.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<List<Product>> getHotest() async {
    try {
      Map<String, String> qParams = {'filter': 'popularity="Best Seller"'};

      var response = await _dio.get('collections/products/records',
          queryParameters: qParams);

      return response.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }
}
