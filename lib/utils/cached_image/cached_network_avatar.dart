import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CachedAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  CachedAvatar({@required this.imageUrl, @required this.radius});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      repeat: ImageRepeat.repeat,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => CircleAvatar(
        child: SpinKitFadingCircle(
          color: Colors.red,
        ),
        radius: radius,
        backgroundColor: Colors.transparent,
      ),
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius ?? 20,
        backgroundImage: imageProvider,
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundImage: AssetImage(
          'assets/images/placeholder.png',
        ),
        radius: radius,
      ),
    );
  }
}
