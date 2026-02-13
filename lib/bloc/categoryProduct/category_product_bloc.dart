import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/categoryProduct/category_product_event.dart';
import 'package:flutter_ecommerce_project/bloc/categoryProduct/category_product_state.dart';
import 'package:flutter_ecommerce_project/data/repository/category_product_repository.dart';
import 'package:flutter_ecommerce_project/di/di.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ICategoryProductRepository _repository = locator.get();

  CategoryProductBloc() : super(CategoryProductLoadingState()) {
    on<CategoryProductInitialize>((event, emit) async {
      var response = await _repository.getProductByCategoryID(event.categoryID);
      emit(CategoryProductResponseSuccessState(response));
    });
  }
}
