import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/category/category_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/category/category_event.dart';
import 'package:flutter_ecommerce_project/bloc/category/category_state.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/widgets/cached_image.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoryBloc>(context).add(CategoryRequestList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgrounScreenColor,
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
                      const Expanded(
                        child: Text(
                          'دسته بندی',
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
            BlocBuilder<CategoryBloc, CategoryState>(
                builder: ((context, state) {
              if (state is CategoryLoadingState) {
                return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (state is CategoryResponseState) {
                return state.response.fold((l) {
                  return SliverToBoxAdapter(child: Center(child: Text(l)));
                }, (r) {
                  return listCategory(list: r);
                });
              }
              return SliverToBoxAdapter(child: Text('error'));
            })),
          ],
        ),
      ),
    );
  }
}

class listCategory extends StatelessWidget {
  final List<Category>? list;
  const listCategory({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            return CachedImage(imageUrl: list?[index].thumbnail);
          }),
          childCount: list?.length ?? 0,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
      ),
    );
  }
}
