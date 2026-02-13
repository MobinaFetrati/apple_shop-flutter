import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_bloc.dart';
import 'package:flutter_ecommerce_project/data/datasource/Comments_datasource.dart';
import 'package:flutter_ecommerce_project/data/datasource/authentication_datasource.dart';
import 'package:flutter_ecommerce_project/data/datasource/banner_datasource.dart';
import 'package:flutter_ecommerce_project/data/datasource/basket_datasource.dart';
import 'package:flutter_ecommerce_project/data/datasource/category_datasource.dart';
import 'package:flutter_ecommerce_project/data/datasource/category_product_datasourse.dart';
import 'package:flutter_ecommerce_project/data/datasource/product_datasource.dart';
import 'package:flutter_ecommerce_project/data/datasource/product_detail_datasource.dart';
import 'package:flutter_ecommerce_project/data/repository/authentication_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/banner_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/basket_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/category_product_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/category_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/comments_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/product_detail_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/product_repository.dart';
import 'package:flutter_ecommerce_project/util/dio_provider.dart';
import 'package:flutter_ecommerce_project/util/payment_handler.dart';
import 'package:flutter_ecommerce_project/util/url_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

var locator = GetIt.instance;
Future<void> getItInit() async {
  await _initComponents();

  //DataSources
  _initDataSources();

  //Repositories
  _initRepositories();

  //bloc
  locator
      .registerSingleton<BasketBloc>(BasketBloc(locator.get(), locator.get()));
}

Future<void> _initComponents() async {
  locator.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());

  //Util
  locator.registerSingleton<UrlHandler>(UrlLauncher());
  locator
      .registerSingleton<PaymentHandler>(ZarinPalPaymentHandler(locator.get()));

  //Components
  locator.registerSingleton<Dio>(DioProvider.createDio());
}

void _initDataSources() {
  locator
      .registerFactory<IAuthenticationDatasource>(() => AuthenticationRemote());
  locator
      .registerFactory<ICategoryDatasource>(() => CategoryRemoteDatasource());

  locator.registerFactory<IBannerDatasource>(() => BannerRemoteDatasource());

  locator.registerFactory<IProductDatasource>(() => ProductRemoteDatasource());

  locator.registerFactory<IDetailProductDatasource>(
      () => DetailProductRemoteDatasource());

  locator.registerFactory<ICategoryProductDatasourse>(
      () => CategoryProductRemoteDatasource());

  locator.registerFactory<IBasketDatasource>(() => BasketLocalDatasource());

  locator
      .registerFactory<ICommentsDatasource>(() => CommentsRemoteDatasource());
}

void _initRepositories() {
  locator.registerFactory<IAuthRepository>(() => AuthenticationRepository());

  locator.registerFactory<ICategoryRepository>(() => CategoryRepository());

  locator.registerFactory<IBannerRepository>(() => BannerRepository());

  locator.registerFactory<IProductRepository>(() => ProductRepository());

  locator.registerFactory<IDetailProductRepository>(
      () => DetailProductRepository());

  locator.registerFactory<ICategoryProductRepository>(
      () => CategoryProductRepository());

  locator.registerFactory<IBasketRepository>(() => BasketRepository());

  locator.registerFactory<ICommentsRepository>(() => CommentsRepository());
}
