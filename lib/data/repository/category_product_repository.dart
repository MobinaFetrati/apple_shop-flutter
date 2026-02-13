import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/datasource/category_product_datasourse.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class ICategoryProductRepository {
  Future<Either<String, List<Product>>> getProductByCategoryID(
      String categoryID);
}

class CategoryProductRepository extends ICategoryProductRepository {
  final ICategoryProductDatasourse _datasource = locator.get();
  @override
  Future<Either<String, List<Product>>> getProductByCategoryID(
      String categoryID) async {
    try {
      var response = await _datasource.getProductByCategoryID(categoryID);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
