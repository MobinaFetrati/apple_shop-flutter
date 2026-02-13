import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/datasource/product_datasource.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class IProductRepository {
  Future<Either<String, List<Product>>> getProducts();
  Future<Either<String, List<Product>>> getBestSeller();
  Future<Either<String, List<Product>>> getHotest();
}

class ProductRepository extends IProductRepository {
  final IProductDatasource _datasource = locator.get();
  @override
  Future<Either<String, List<Product>>> getProducts() async {
    try {
      var response = await _datasource.getProducts();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<Product>>> getHotest() async {
    try {
      var response = await _datasource.getBestSeller();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<Product>>> getBestSeller() async {
    try {
      var response = await _datasource.getHotest();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
