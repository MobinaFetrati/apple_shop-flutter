import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';

abstract class CategoryProductState {}

class CategoryProductLoadingState extends CategoryProductState {}

class CategoryProductResponseSuccessState extends CategoryProductState {
  Either<String, List<Product>> productListByCategoryID;

  CategoryProductResponseSuccessState(this.productListByCategoryID);
}
