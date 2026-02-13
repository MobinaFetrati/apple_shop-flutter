import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:flutter_ecommerce_project/data/model/banner1.dart';
import 'package:flutter_ecommerce_project/widgets/cached_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  List<Banner1> bannerList;
  BannerSlider(
    this.bannerList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = PageController(viewportFraction: 0.9);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: 177,
            child: PageView.builder(
                controller: controller,
                itemCount: bannerList.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: CachedImage(
                      imageUrl: bannerList[index].thumbnail,
                      radius: 15,
                    ),
                  );
                })),
          ),
        ),
        Positioned(
          bottom: 10,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SmoothPageIndicator(
              controller: controller,
              count: bannerList.length,
              effect: const ExpandingDotsEffect(
                  expansionFactor: 5,
                  dotColor: Colors.white,
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: CustomColors.blueIndicator),
            ),
          ),
        ),
      ],
    );
  }
}
