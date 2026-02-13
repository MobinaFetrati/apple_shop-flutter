import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/data/model/product_image.dart';
import 'package:flutter_ecommerce_project/data/model/product_properties.dart';
import 'package:flutter_ecommerce_project/data/model/product_variant.dart';
import 'package:flutter_ecommerce_project/data/model/variant.dart';
import 'package:flutter_ecommerce_project/data/model/variant_type.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class IDetailProductDatasource {
  Future<List<ProductImage>> getProductImage(String productID);
  Future<List<VariantType>> getVariantTypes();
  Future<List<Variant>> getVariants(String productID);
  Future<List<ProductVariant>> getProductVariants(String productID);
  Future<Category> getProductCategory(String categoryID);
  Future<List<Property>> getProductProperties(String categoryID);
}

class DetailProductRemoteDatasource extends IDetailProductDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<ProductImage>> getProductImage(String productID) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productID"'};
      var response = await _dio.get('collections/gallery/records',
          queryParameters: qParams);
      return response.data['items']
          .map<ProductImage>((jsonObject) => ProductImage.fromJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<List<VariantType>> getVariantTypes() async {
    try {
      var response = await _dio.get('collections/variants_type/records');
      return response.data['items']
          .map<VariantType>((jsonObject) => VariantType.fromJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<List<Variant>> getVariants(String productID) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productID"'};
      var response = await _dio.get('collections/variants/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Variant>((jsonObject) => Variant.fromJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<List<ProductVariant>> getProductVariants(String productID) async {
    var variantTypeList = await getVariantTypes();
    var variantList = await getVariants(productID);
    List<ProductVariant> productVariantList = [];

    try {
      for (var variantType in variantTypeList) {
        var pvariantList = variantList
            .where((element) => element.typeId == variantType.id)
            .toList();

        productVariantList.add(ProductVariant(variantType, pvariantList));
      }
      return productVariantList;
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<Category> getProductCategory(String categoryID) async {
    try {
      Map<String, String> qParams = {'filter': 'id="$categoryID"'};
      var response = await _dio.get('collections/Category/records',
          queryParameters: qParams);
      return Category.fromMapJson(response.data['items'][0]);
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<List<Property>> getProductProperties(String productID) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productID"'};
      var response = await _dio.get('collections/properties/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Property>((jsonObject) => Property.fromJson(jsonObject))
          .toList();
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }
}
