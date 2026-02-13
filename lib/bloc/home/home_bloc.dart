import 'package:bloc/bloc.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_event.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_state.dart';
import 'package:flutter_ecommerce_project/data/repository/category_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/product_repository.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/data/repository/banner_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository _bannerRepository = locator.get();

  final ICategoryRepository _categoryRepository = locator.get();

  final IProductRepository _productRepository = locator.get();

  HomeBloc() : super(HomeInitState()) {
    on<HomeGetInitializedData>((event, emit) async {
      emit(HomeLoadingState());

      var bannerList = await _bannerRepository.getBanners();

      var categoryList = await _categoryRepository.getCategories();

      var productList = await _productRepository.getProducts();

      var bestSellerProductList = await _productRepository.getBestSeller();
      var hotestProductList = await _productRepository.getHotest();

      emit(HomeRequestSuccessState(bannerList, categoryList, productList,
          bestSellerProductList, hotestProductList));
    });
  }
}
