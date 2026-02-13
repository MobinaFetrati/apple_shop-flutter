import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  String? imageUrl;
  double radius;
  CachedImage({super.key, this.imageUrl, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageUrl: imageUrl ??
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Ftiktarh.com%2Fproduct%2F%25D8%25AF%25D8%25A7%25D9%2586%25D9%2584%25D9%2588%25D8%25AF-%25D9%2588%25DA%25A9%25D8%25AA%25D9%2588%25D8%25B1-%25D9%2585%25D9%2581%25D9%2587%25D9%2588%25D9%2585%25DB%258C-%25D8%25A7%25D8%25B1%25D9%2588%25D8%25B1-404-%25D8%25A7%25DB%258C%25D9%2586%25D8%25AA%25D8%25B1%25D9%2586%25D8%25AA&psig=AOvVaw3e0Yc5zBmDM_-cK4kStfZg&ust=1755022341092000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCNCx2I-ug48DFQAAAAAdAAAAABAE',
        errorWidget: (context, url, error) => Container(color: Colors.blue),
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey),
      ),
    );
  }
}
