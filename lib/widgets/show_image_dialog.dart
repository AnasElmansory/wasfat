import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImageDialog extends StatelessWidget {
  final String photoUrl;

  const ShowImageDialog({Key key, this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.black12,
      child: Container(
        height: size.height * 0.6,
        width: size.width * 0.8,
        child: PhotoView.customChild(
            minScale: PhotoViewComputedScale.covered,
            tightMode: true,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black12,
            ),
            heroAttributes: PhotoViewHeroAttributes(tag: 'profileImage'),
            child: CachedNetworkImage(imageUrl: photoUrl)),
      ),
    );
  }
}
