import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_event.dart';
import 'package:flutter_ecommerce_project/bloc/home/home_state.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/banner1.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/data/model/product.dart';
import 'package:flutter_ecommerce_project/widgets/banner_slider.dart';
import 'package:flutter_ecommerce_project/widgets/category_icon_item_chip.dart';
import 'package:flutter_ecommerce_project/widgets/loading_animation.dart';
import 'package:flutter_ecommerce_project/widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgrounScreenColor,
      body: SafeArea(
        child: Center(
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            return _getHomeScreenContent(state, context);
          }),
        ),
      ),
    );
  }
}

Widget _getHomeScreenContent(HomeState state, BuildContext context) {
  if (state is HomeLoadingState) {
    return Center(
      child: LoadingAnimation(),
    );
  } else if (state is HomeRequestSuccessState) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeGetInitializedData());
      },
      child: CustomScrollView(
        slivers: [
          _getSearchBox(),
          state.bannerList.fold((exeptionMessage) {
            return SliverToBoxAdapter(
              child: Text(exeptionMessage),
            );
          }, (listBanners) {
            return _getBanners(listBanners);
          }),
          _getCategoryListTitle(),
          state.categoryList.fold((exeptionMessage) {
            return SliverToBoxAdapter(
              child: Text(exeptionMessage),
            );
          }, (categoryList) {
            return _getCategoryList(categoryList);
          }),
          _getBestSellerTitle(),
          state.bestSellerProductList.fold((exeptionMessage) {
            return SliverToBoxAdapter(
              child: Text(exeptionMessage),
            );
          }, (productList) {
            return _getBestSellerProducts(productList);
          }),
          _getMostViewedTitle(),
          state.hotestProductList.fold((exeptionMessage) {
            return SliverToBoxAdapter(
              child: Text(exeptionMessage),
            );
          }, (productList) {
            return _getMostViewedProducts(productList);
          }),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 10),
          ),
        ],
      ),
    );
  } else {
    return Center(
      child: Text('خطایی در دریافت اطلاعات به وجود آمده'),
    );
  }
}

class _getSearchBox extends StatelessWidget {
  const _getSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
              Image.asset('assets/images/icon_search.png'),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'جستجوی محصولات',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'SB',
                    fontSize: 15,
                    color: CustomColors.gray,
                  ),
                ),
              ),
              Image.asset('assets/images/icon_apple_blue.png'),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class _getBanners extends StatelessWidget {
  List<Banner1> banner1;
  _getBanners(
    this.banner1, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BannerSlider(banner1),
    );
  }
}

class _getCategoryListTitle extends StatelessWidget {
  const _getCategoryListTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'دسته بندی',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _getCategoryList extends StatelessWidget {
  List<Category> listCategories;
  _getCategoryList(
    this.listCategories, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 15),
                child: CategoryItemChip(listCategories[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _getBestSellerTitle extends StatelessWidget {
  const _getBestSellerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
        child: Row(
          children: [
            const Text(
              'پر فروش ترین ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.gray,
              ),
            ),
            const Spacer(),
            const Text(
              'مشاهده همه',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class _getBestSellerProducts extends StatelessWidget {
  final List<Product> productList;
  _getBestSellerProducts(
    this.productList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 15),
                child: ProductItem(productList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _getMostViewedTitle extends StatelessWidget {
  const _getMostViewedTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(right: 15, left: 15, bottom: 15, top: 20),
        child: Row(
          children: [
            const Text(
              'پر بازدیدترین ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.gray,
              ),
            ),
            const Spacer(),
            const Text(
              'مشاهده همه',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class _getMostViewedProducts extends StatelessWidget {
  List<Product> productList;
  _getMostViewedProducts(
    this.productList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 15),
                child: ProductItem(productList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
