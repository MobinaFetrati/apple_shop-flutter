import 'package:bloc/bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_event.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_state.dart';
import 'package:flutter_ecommerce_project/data/repository/basket_repository.dart';
import 'package:flutter_ecommerce_project/util/payment_handler.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final IBasketRepository _basketrepository;
  final PaymentHandler _paymentHandler;

  BasketBloc(this._basketrepository, this._paymentHandler)
      : super(BasketInitState()) {
    on<BasketFetchFromHiveEvent>(((event, emit) async {
      var basketItemList = await _basketrepository.getAllBasketItems();
      var finalPrice = await _basketrepository.getBasketFinalPrice();
      emit(BasketDataFetchedState(basketItemList, finalPrice));
    }));

    on<BasketPaymentInitEvent>((event, emit) async {
      var finalPrice = await _basketrepository.getBasketFinalPrice();
      _paymentHandler.initPaymentRequest(finalPrice);
    });

    on<BasketPaymentRequestEvent>((event, emit) async {
      _paymentHandler.sendPaymentRequest();
    });

    on<BasketRemoveProductEvent>((event, emit) async {
      _basketrepository.removeProduct(event.index);

      var basketItemList = await _basketrepository.getAllBasketItems();
      var finalPrice = await _basketrepository.getBasketFinalPrice();
      emit(BasketDataFetchedState(basketItemList, finalPrice));
    });
  }
}
