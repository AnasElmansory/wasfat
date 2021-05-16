import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import 'package:wasfat_akl/widgets/core/cached_image.dart';

class ShowImageDialog extends StatelessWidget {
  final String photoUrl;

  const ShowImageDialog({Key? key, required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final _size = Size.square(size.width * .85);
    return Dialog(
      backgroundColor: Colors.black12,
      child: Container(
        height: _size.height,
        width: _size.width,
        child: PhotoView.customChild(
          minScale: PhotoViewComputedScale.covered,
          tightMode: true,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black12,
          ),
          heroAttributes: PhotoViewHeroAttributes(tag: 'profileImage'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedImage(
              url: photoUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
