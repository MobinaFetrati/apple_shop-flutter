import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_project/constants/custom_colors.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Center(
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: const [CustomColors.blueIndicator],
          strokeWidth: 2,
        ),
      ),
    );
  }
}
