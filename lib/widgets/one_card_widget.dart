import 'package:flutter/material.dart';
import 'package:wasfat_akl/widgets/cached_image.dart';

class OneCardWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Size size;
  final Color textBackgroundColor;
  final Color textColor;
  static const Color mTextBackgroundColor = Color.fromRGBO(129, 129, 129, 0.6);

  OneCardWidget({
    required this.name,
    required this.imageUrl,
    required this.size,
    this.textBackgroundColor = mTextBackgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        width: size.width,
        height: size.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned(
                height: size.height,
                width: size.width,
                child: CachedImage(url: imageUrl),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                      color: textBackgroundColor,
                      gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.black,
                            Colors.black12,
                            Color.fromRGBO(255, 255, 255, 0.2)
                          ])),
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        name,
                        style: TextStyle(color: textColor, fontSize: 18),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
