import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/data/model/banner1.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

import '../../di/di.dart';

abstract class IBannerDatasource {
  Future<List<Banner1>> getBanners();
}

class BannerRemoteDatasource extends IBannerDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Banner1>> getBanners() async {
    try {
      var response = await _dio.get('collections/banner/records');
      return response.data['items']
          .map<Banner1>((jsonObject) => Banner1.fromJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }
}
