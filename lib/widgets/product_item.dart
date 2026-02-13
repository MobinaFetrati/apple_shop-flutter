import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_bloc.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/screens/product_detail_screen.dart';
import 'package:flutter_ecommerce_project/util/extentions/double_extentions.dart';
import 'package:flutter_ecommerce_project/widgets/cached_image.dart';
// import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  Product product;
  ProductItem(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<BasketBloc>.value(
              value: locator.get<BasketBloc>(),
              child: ProductDetailScreen(product),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        height: 220,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: 95,
                  height: 100,
                  child:
                      Center(child: CachedImage(imageUrl: product.thumbnail)),
                ),
                Positioned(
                  top: 0,
                  right: 15,
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/images/active_fav_product.png'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: Text(
                        '${product.persent!.round().toString()}%',
                        style: TextStyle(
                          fontFamily: 'SB',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 10),
                  child: Text(
                    product.name,
                    maxLines: 1,
                    style: TextStyle(fontFamily: 'SM', fontSize: 14),
                  ),
                ),
                Container(
                  height: 55,
                  decoration: const BoxDecoration(
                    color: CustomColors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.blue,
                        blurRadius: 25,
                        spreadRadius: -12,
                        offset: Offset(0.0, 15),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'تومان',
                            style: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(product.price.convertToPrice(),
                                  style: TextStyle(
                                      fontFamily: 'SM',
                                      fontSize: 13,
                                      color: Colors.white,
                                      decoration: TextDecoration.lineThrough)),
                              Text(
                                product.realPrice!.convertToPrice(),
                                style: TextStyle(
                                  fontFamily: 'SM',
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 25,
                            child: Image.asset(
                                'assets/images/icon_right_arrow_cricle.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
