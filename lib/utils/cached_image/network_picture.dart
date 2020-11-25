import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkPicture extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final String imageUrl;
  NetworkPicture(
      {this.height, this.width, this.radius, @required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Center(
//        height: height ?? null,
//        width: width ?? null,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height ?? null,
        width: width ?? null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 4),
          child: Image.asset(
            'assets/images/placeholder.png',
          ),
        ),
      ),
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height ?? null,
        width: width ?? null,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 4),
            child: Image.network(
              imageUrl,
              // fit: BoxFit.fill,
            )),
      ),
      fit: BoxFit.cover,
    );
  }
}
