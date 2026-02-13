import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/datasource/category_datasource.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class ICategoryRepository {
  Future<Either<String, List<Category>>> getCategories();

  getProducts() {}
}

class CategoryRepository extends ICategoryRepository {
  final ICategoryDatasource _datasource = locator.get();
  @override
  Future<Either<String, List<Category>>> getCategories() async {
    try {
      var response = await _datasource.getCategories();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
