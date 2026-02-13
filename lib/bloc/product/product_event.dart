import 'package:flutter_ecommerce_project/data/model/product.dart';

abstract class ProductEvent {}

class ProductInitializedEvent extends ProductEvent {
  String productID;
  String categoryID;
  ProductInitializedEvent(this.productID, this.categoryID);
}

class ProductAddToBasket extends ProductEvent {
  Product product;
  ProductAddToBasket(this.product);
}
