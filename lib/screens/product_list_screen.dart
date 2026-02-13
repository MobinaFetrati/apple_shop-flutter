import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/categoryProduct/category_product_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/categoryProduct/category_product_event.dart';
import 'package:flutter_ecommerce_project/bloc/categoryProduct/category_product_state.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  Category category;
  ProductListScreen(this.category, {super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoryProductBloc>(context)
        .add(CategoryProductInitialize(widget.category.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductBloc, CategoryProductState>(
      builder: ((context, state) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 45,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Image.asset('assets/images/icon_apple_blue.png'),
                          Expanded(
                            child: Text(
                              widget.category.title!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SB',
                                fontSize: 15,
                                color: CustomColors.blue,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(); // برگشت به صفحه قبل
                            },
                            child: Image.asset('assets/images/icon_back.png'),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state is CategoryProductLoadingState) ...{
                  SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                },
                if (state is CategoryProductResponseSuccessState) ...{
                  state.productListByCategoryID.fold((exeptionMessage) {
                    return SliverToBoxAdapter(
                      child: Text(exeptionMessage),
                    );
                  }, (productList) {
                    return SliverPadding(
                      padding: const EdgeInsets.all(15),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          ((context, index) {
                            return ProductItem(productList[index]);
                          }),
                          childCount: productList.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2 / 2.5,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 30),
                      ),
                    );
                  })
                }
              ],
            ),
          ),
        );
      }),
    );
  }
}
