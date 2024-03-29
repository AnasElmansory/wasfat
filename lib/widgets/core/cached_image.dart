import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  const CachedImage({Key? key, required this.url, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: url,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) {
          return Image.asset(
            'assets/placeholder.png',
            fit: BoxFit.cover,
          );
        },
        errorWidget: (_, __, ___) {
          return const ImageIcon(
            const AssetImage('assets/transparent_logo.ico'),
            color: Colors.grey,
            size: 30,
          );
        });
  }
}
