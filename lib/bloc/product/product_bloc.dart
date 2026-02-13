import 'package:bloc/bloc.dart';
import 'package:flutter_ecommerce_project/bloc/product/product_event.dart';
import 'package:flutter_ecommerce_project/bloc/product/product_state.dart';
import 'package:flutter_ecommerce_project/data/model/card_item.dart';
import 'package:flutter_ecommerce_project/data/repository/basket_repository.dart';
import 'package:flutter_ecommerce_project/data/repository/product_detail_repository.dart';
import 'package:flutter_ecommerce_project/di/di.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IDetailProductRepository _productRepository = locator.get();
  final IBasketRepository _basketRepository = locator.get();

  ProductBloc() : super(ProductInitState()) {
    on<ProductInitializedEvent>((event, emit) async {
      emit(ProductDetailLoadingState());

      var productImages =
          await _productRepository.getProductImage(event.productID);

      var productVariant =
          await _productRepository.getProductVariants(event.productID);

      var productCategory =
          await _productRepository.getProductCategory(event.categoryID);

      var productProperties =
          await _productRepository.getProductProperties(event.productID);

      emit(ProductDetailResponseState(
          productImages, productVariant, productCategory, productProperties));
    });

    on<ProductAddToBasket>(((event, emit) {
      var basketItem = BasketItem(
          event.product.id,
          event.product.collectionId,
          event.product.thumbnail,
          event.product.discount_price,
          event.product.price,
          event.product.name,
          event.product.categoryID);

      _basketRepository.addProductToBasket(basketItem);
    }));
  }
}
