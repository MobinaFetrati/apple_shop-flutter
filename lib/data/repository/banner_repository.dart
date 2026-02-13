import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/datasource/banner_datasource.dart';
import 'package:flutter_ecommerce_project/data/model/banner1.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class IBannerRepository {
  Future<Either<String, List<Banner1>>> getBanners();
}

class BannerRepository extends IBannerRepository {
  final IBannerDatasource datasource = locator.get();
  @override
  Future<Either<String, List<Banner1>>> getBanners() async {
    try {
      var response = await datasource.getBanners();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
