import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/datasource/product_detail_datasource.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/data/model/product_image.dart';
import 'package:flutter_ecommerce_project/data/model/product_properties.dart';
import 'package:flutter_ecommerce_project/data/model/product_variant.dart';
import 'package:flutter_ecommerce_project/data/model/variant_type.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class IDetailProductRepository {
  Future<Either<String, List<ProductImage>>> getProductImage(String productID);

  Future<Either<String, List<VariantType>>> getVariantTypes();

  Future<Either<String, List<ProductVariant>>> getProductVariants(
      String productID);

  Future<Either<String, Category>> getProductCategory(String categoryID);

  Future<Either<String, List<Property>>> getProductProperties(String productID);
}

class DetailProductRepository extends IDetailProductRepository {
  final IDetailProductDatasource _datasource = locator.get();

  @override
  Future<Either<String, List<ProductImage>>> getProductImage(
      String productID) async {
    try {
      var response = await _datasource.getProductImage(productID);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<VariantType>>> getVariantTypes() async {
    try {
      var response = await _datasource.getVariantTypes();
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<ProductVariant>>> getProductVariants(
      String productID) async {
    try {
      var response = await _datasource.getProductVariants(productID);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, Category>> getProductCategory(String categoryID) async {
    try {
      var response = await _datasource.getProductCategory(categoryID);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<Property>>> getProductProperties(
      String productID) async {
    try {
      var response = await _datasource.getProductProperties(productID);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
