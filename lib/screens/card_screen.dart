import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_event.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_state.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/card_item.dart';
import 'package:flutter_ecommerce_project/util/extentions/double_extentions.dart';
import 'package:flutter_ecommerce_project/util/extentions/string_extentions.dart';
import 'package:flutter_ecommerce_project/widgets/cached_image.dart';

class CardScreen extends StatelessWidget {
  CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgrounScreenColor,
      body: SafeArea(
        child: BlocBuilder<BasketBloc, BasketState>(
          builder: ((context, state) {
            return Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: 45,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              Image.asset('assets/images/icon_apple_blue.png'),
                              const Expanded(
                                child: Text(
                                  'سبد خرید',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SB',
                                    fontSize: 15,
                                    color: CustomColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (state is BasketDataFetchedState) ...{
                      state.basketItemList.fold(
                        ((l) {
                          return SliverToBoxAdapter(
                            child: Text(l),
                          );
                        }),
                        ((basketItemList) {
                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              return CardItem(basketItemList[index], index);
                            }, childCount: basketItemList.length),
                          );
                        }),
                      ),
                    },
                    SliverPadding(padding: EdgeInsets.only(bottom: 50))
                  ],
                ),
                if (state is BasketDataFetchedState) ...{
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        onPressed: () {
                          if (state.basketFinalPrice != 0) {
                            context
                                .read<BasketBloc>()
                                .add(BasketPaymentInitEvent());
                            context
                                .read<BasketBloc>()
                                .add(BasketPaymentRequestEvent());
                          }
                          print('سبد خالیه');
                        },
                        child: Text(
                          (state.basketFinalPrice == 0)
                              ? 'سبد خرید خالیه'
                              : 'مبلغ پرداختی : ${state.basketFinalPrice.convertToPrice()}',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                }
              ],
            );
          }),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final BasketItem basketItem;
  final int index;
  const CardItem(this.basketItem, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          basketItem.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SB',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'گارانتی فیلان 18 ماهه',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 12,
                            color: CustomColors.gray,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Text(
                                  '%3',
                                  style: TextStyle(
                                    fontFamily: 'S',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'تومان',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SM',
                                fontSize: 12,
                                color: CustomColors.gray,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${basketItem.realPrice!.convertToPrice()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SM',
                                fontSize: 12,
                                color: CustomColors.gray,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<BasketBloc>()
                                    .add(BasketRemoveProductEvent(index));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: CustomColors.red,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          textDirection: TextDirection.rtl,
                                          'حذف',
                                          style: TextStyle(
                                            fontFamily: 'SM',
                                            fontSize: 12,
                                            color: CustomColors.red,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Image.asset(
                                            'assets/images/icon_trash.png')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            OptionChip(
                              'آبی',
                              color: '1234f5',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                      height: 104,
                      width: 75,
                      child: CachedImage(imageUrl: basketItem.thumbnail)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DottedLine(
              lineThickness: 3,
              dashLength: 8,
              dashColor: CustomColors.gray.withOpacity(0.2),
              dashGapLength: 3,
              dashGapColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'تومان',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SB',
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '${basketItem.realPrice!.convertToPrice()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SB',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionChip extends StatelessWidget {
  final String? color;
  final String title;
  const OptionChip(this.title, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: CustomColors.gray,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (color != null) ...{
                Container(
                  margin: EdgeInsets.only(right: 5),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.parseToColor(),
                  ),
                )
              },
              Text(
                textDirection: TextDirection.rtl,
                title,
                style: TextStyle(
                  fontFamily: 'SM',
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
