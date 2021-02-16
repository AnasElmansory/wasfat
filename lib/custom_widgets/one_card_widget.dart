import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OneCardWidget extends StatelessWidget {
  final String name;
  final String imageUrl;

  final Size size;
  final Color textBackgroundColor;
  final Color textColor;
  static const Color mTextBackgroundColor = Color.fromRGBO(129, 129, 129, 0.6);

  OneCardWidget({
    this.name,
    this.imageUrl,
    this.size,
    this.textBackgroundColor = mTextBackgroundColor,
    this.textColor,
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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    placeholder: (context, url) {
                      return ImageIcon(
                        const AssetImage('assets/transparent_logo.ico'),
                        size: 30,
                        color: Colors.grey[200],
                      );
                    },
                  )),
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
                            Colors.black12,
                            Color.fromRGBO(255, 255, 255, 0.2)
                          ])),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        name,
                        style: TextStyle(color: textColor, fontSize: 18),
                        textAlign: TextAlign.right,
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
