import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/model/banner1.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeRequestSuccessState extends HomeState {
  Either<String, List<Banner1>> bannerList;

  Either<String, List<Category>> categoryList;

  Either<String, List<Product>> productList;

  Either<String, List<Product>> bestSellerProductList;
  Either<String, List<Product>> hotestProductList;

  HomeRequestSuccessState(this.bannerList, this.categoryList, this.productList,
      this.hotestProductList, this.bestSellerProductList);
}
