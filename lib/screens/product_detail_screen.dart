import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/basket/basket_event.dart';
import 'package:flutter_ecommerce_project/bloc/comments/comments_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/comments/comments_event.dart';
import 'package:flutter_ecommerce_project/bloc/comments/comments_state.dart';
import 'package:flutter_ecommerce_project/bloc/product/product_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/product/product_event.dart';
import 'package:flutter_ecommerce_project/bloc/product/product_state.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/data/model/product_image.dart';
import 'package:flutter_ecommerce_project/data/model/product_properties.dart';
import 'package:flutter_ecommerce_project/data/model/product_variant.dart';
import 'package:flutter_ecommerce_project/data/model/variant.dart';
import 'package:flutter_ecommerce_project/data/model/variant_type.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/widgets/cached_image.dart';
import 'package:flutter_ecommerce_project/widgets/loading_animation.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen(this.product, {super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) {
        var bloc = ProductBloc();
        bloc.add(ProductInitializedEvent(
            widget.product.id, widget.product.categoryID));
        return bloc;
      }),
      child: DetailScreenContent(parentWidget: widget),
    );
  }
}

class DetailScreenContent extends StatelessWidget {
  const DetailScreenContent({
    super.key,
    required this.parentWidget,
  });

  final ProductDetailScreen parentWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgrounScreenColor,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductDetailLoadingState) {
            return Center(child: LoadingAnimation());
          }
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                if (state is ProductDetailResponseState) ...{
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
                            Expanded(
                                child: state.productCategory.fold((l) {
                              return Text(
                                'اطلاعات محصول',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SB',
                                  fontSize: 15,
                                  color: CustomColors.blue,
                                ),
                              );
                            }, (productCategory) {
                              return Text(
                                productCategory.title!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'SB',
                                  fontSize: 15,
                                  color: CustomColors.blue,
                                ),
                              );
                            })),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); // برگشت به صفحه قبل
                              },
                              child: Image.asset('assets/images/icon_back.png'),
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    ),
                  )
                },
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        parentWidget.product.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SB',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                },
                if (state is ProductDetailResponseState) ...[
                  state.productImages.fold((exeptionMessage) {
                    return SliverToBoxAdapter(
                      child: Text(exeptionMessage),
                    );
                  }, (productImageList) {
                    return GalleryWidget(
                        parentWidget.product.thumbnail, productImageList);
                  })
                ],
                if (state is ProductDetailResponseState) ...[
                  state.productVariant.fold((exeptionMessage) {
                    return SliverToBoxAdapter(
                      child: Text(exeptionMessage),
                    );
                  }, (productVariantList) {
                    return VariantContainerGenerator(productVariantList);
                  })
                ],
                if (state is ProductDetailResponseState) ...{
                  state.productProperties.fold((exeptionMessage) {
                    return SliverToBoxAdapter(
                      child: Text(exeptionMessage),
                    );
                  }, (propertyList) {
                    return ProductProperties(propertyList);
                  })
                },
                if (state is ProductDetailResponseState) ...{
                  ProductDescription(parentWidget.product.description),
                },
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            useSafeArea: true,
                            showDragHandle: true,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) {
                                  final bloc = CommentsBloc(locator.get());
                                  bloc.add(CommentsInitializedEvent(
                                      parentWidget.product.id));
                                  return bloc;
                                },
                                child: CommentBottomSheet(
                                    productID: parentWidget.product.id),
                              );
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: CustomColors.gray,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Image.asset('assets/images/icon_left_categroy.png'),
                            const SizedBox(width: 10),
                            Text(
                              'مشاهده',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SB',
                                fontSize: 12,
                                color: CustomColors.blue,
                              ),
                            ),
                            Spacer(),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                Positioned(
                                  right: 15,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                ),
                                Positioned(
                                  right: 30,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                ),
                                Positioned(
                                  right: 45,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                ),
                                Positioned(
                                  right: 60,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Center(
                                      child: Text(
                                        '+10',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SB',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Text(
                              ': نظرات کاربران',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SB',
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                },
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PriceTagBottom(),
                          AddToBascketBottom(parentWidget.product),
                        ],
                      ),
                    ),
                  ),
                }
              ],
            ),
          );
        },
      ),
    );
  }
}

class CommentBottomSheet extends StatelessWidget {
  CommentBottomSheet({
    required this.productID,
    super.key,
  });
  final String productID;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(builder: (context, state) {
      if (state is CommentsLoadingState) {
        return Center(
          child: LoadingAnimation(),
        );
      }
      return Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (state is CommentsResponseState) ...{
                  state.response.fold((l) {
                    return SliverToBoxAdapter(
                      child: Text('is Loading'),
                    );
                  }, (commentList) {
                    if (commentList.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "نظری درباره این محصول وجود ندارد",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin:
                                EdgeInsets.only(top: 15, left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 226, 224, 224),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        (commentList[index]
                                                .userName
                                                .trim()
                                                .isEmpty)
                                            ? 'کاربر'
                                            : commentList[index].userName,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        commentList[index].text,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: (commentList[index].avatar.isNotEmpty)
                                      ? CachedImage(
                                          imageUrl: commentList[index]
                                              .userThumnailUrl,
                                        )
                                      : Image.asset(
                                          'assets/images/avatar.png',
                                        ),
                                )
                              ],
                            ),
                          );
                        },
                        childCount: commentList.length,
                      ),
                    );
                  })
                }
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    style: TextStyle(
                      fontFamily: 'SM',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: 'SM',
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 3)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide:
                            BorderSide(color: CustomColors.blue, width: 3),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (textController.text.isEmpty) return;

                            context.read<CommentsBloc>().add(
                                  CommentsPostEvent(
                                      productID, textController.text),
                                );

                            textController.text = '';
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: CustomColors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: SizedBox(
                                height: 45,
                                child: Center(
                                  child: Text(
                                    'ثبت نظر',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SB',
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}

class ProductProperties extends StatefulWidget {
  List<Property> productPropertyList;
  ProductProperties(
    this.productPropertyList, {
    super.key,
  });

  @override
  State<ProductProperties> createState() => _ProductPropertiesState();
}

class _ProductPropertiesState extends State<ProductProperties> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: CustomColors.gray,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Image.asset('assets/images/icon_left_categroy.png'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  child: Text(
                    'مشاهده',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 12,
                      color: CustomColors.blue,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  ': مشخصات فنی',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SB',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: CustomColors.gray,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.productPropertyList.length,
                itemBuilder: (BuildContext context, int index) {
                  var property = widget.productPropertyList[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          '${property.value!} : ${property.title!}',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 14,
                            height: 2,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  String productDescription;
  ProductDescription(
    this.productDescription, {
    super.key,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: CustomColors.gray,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Image.asset('assets/images/icon_left_categroy.png'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  child: Text(
                    'مشاهده',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 12,
                      color: CustomColors.blue,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  ': توضیحات محصول',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SB',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: CustomColors.gray,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                textDirection: TextDirection.rtl,
                widget.productDescription,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'SM',
                  fontSize: 14,
                  height: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VariantContainerGenerator extends StatelessWidget {
  List<ProductVariant> productVariantList;
  VariantContainerGenerator(
    this.productVariantList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          for (var productVariant in productVariantList) ...{
            if (productVariant.variantList.isNotEmpty) ...{
              VariantGeneratorChild(productVariant)
            }
          }
        ],
      ),
    );
  }
}

class VariantGeneratorChild extends StatelessWidget {
  ProductVariant productVariant;
  VariantGeneratorChild(this.productVariant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            productVariant.variantType.title!,
            style: TextStyle(
              fontFamily: 'SM',
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          if (productVariant.variantType.type == VariantTypeEnum.COLOR) ...{
            ColorVariantList(productVariant.variantList)
          },
          if (productVariant.variantType.type == VariantTypeEnum.STORAGE) ...{
            StorageVariantList(productVariant.variantList)
          }
        ],
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  List<ProductImage> productImageList;
  String? defultProductThumbnail;
  int selectedItem = 0;
  GalleryWidget(
    this.defultProductThumbnail,
    this.productImageList, {
    super.key,
  });

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/icon_star.png'),
                          SizedBox(width: 3),
                          Text(
                            '4.6',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        height: 150,
                        child: CachedImage(
                            imageUrl: (widget.productImageList.isEmpty)
                                ? widget.defultProductThumbnail
                                : widget.productImageList[widget.selectedItem]
                                    .imageUrl),
                      ),
                      Spacer(),
                      Image.asset('assets/images/icon_favorite_deactive.png'),
                    ],
                  ),
                ),
              ),
              if (widget.productImageList.isNotEmpty) ...{
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productImageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.selectedItem = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            padding: EdgeInsets.all(5),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                width: 1,
                                color: CustomColors.gray,
                              ),
                            ),
                            child: CachedImage(
                              imageUrl: widget.productImageList[index].imageUrl,
                              radius: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
              }
            ],
          ),
        ),
      ),
    );
  }
}

class PriceTagBottom extends StatelessWidget {
  const PriceTagBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 130,
          height: 60,
          decoration: const BoxDecoration(
            color: CustomColors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 150,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'تومان',
                      style: TextStyle(
                        fontFamily: 'SM',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('48,800,000',
                            style: TextStyle(
                                fontFamily: 'SM',
                                fontSize: 12,
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough)),
                        Text(
                          '39,900,000',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        child: Text(
                          '%3',
                          style: TextStyle(
                            fontFamily: 'SB',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddToBascketBottom extends StatelessWidget {
  Product product;
  AddToBascketBottom(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 130,
          height: 60,
          decoration: const BoxDecoration(
            color: CustomColors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        Positioned(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: GestureDetector(
                onTap: () {
                  context.read<ProductBloc>().add(ProductAddToBasket(product));
                  context.read<BasketBloc>().add(BasketFetchFromHiveEvent());
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      'افزودن به سبد خرید',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ColorVariantList extends StatefulWidget {
  List<Variant> variantList;
  ColorVariantList(this.variantList, {super.key});

  @override
  State<ColorVariantList> createState() => _ColorVariantListState();
}

class _ColorVariantListState extends State<ColorVariantList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.variantList.length,
          itemBuilder: (BuildContext context, int index) {
            String categoryColor = 'ff${widget.variantList[index].value}';
            int hexColor = int.parse(categoryColor, radix: 16);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(2),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    border: (_selectedIndex == index)
                        ? Border.all(
                            width: 1,
                            color: CustomColors.blueIndicator,
                            strokeAlign: BorderSide.strokeAlignOutside)
                        : Border.all(width: 1, color: Colors.white),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(hexColor),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StorageVariantList extends StatefulWidget {
  List<Variant> storageVariants;
  StorageVariantList(this.storageVariants, {super.key});

  @override
  State<StorageVariantList> createState() => _StorageVariantListState();
}

class _StorageVariantListState extends State<StorageVariantList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.storageVariants.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                height: 25,
                decoration: BoxDecoration(
                  border: (_selectedIndex == index)
                      ? Border.all(width: 2, color: CustomColors.blueIndicator)
                      : Border.all(width: 1, color: CustomColors.gray),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      widget.storageVariants[index].value!,
                      style: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
