import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_project/bloc/categoryProduct/category_product_bloc.dart';
import 'package:flutter_ecommerce_project/data/model/category.dart';
import 'package:flutter_ecommerce_project/screens/product_list_screen.dart';
import 'package:flutter_ecommerce_project/widgets/cached_image.dart';

class CategoryItemChip extends StatelessWidget {
  final Category category;
  CategoryItemChip(
    this.category, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String categoryColor = 'ff${category.color}';
    int hexColor = int.parse(categoryColor, radix: 16);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: ((contex) => CategoryProductBloc()),
              child: ProductListScreen(category),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                    color: Color(hexColor),
                    shadows: const [
                      BoxShadow(
                        color: Colors.redAccent,
                        blurRadius: 30,
                        spreadRadius: -10,
                        offset: Offset(0.0, 10),
                      ),
                    ],
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
              SizedBox(
                  width: 25,
                  height: 25,
                  child: Center(child: CachedImage(imageUrl: category.icon))),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            category.title ?? 'محصول',
            style: TextStyle(fontFamily: 'SB', fontSize: 12),
          ),
        ],
      ),
    );
  }
}
