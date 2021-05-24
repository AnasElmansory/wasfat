import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wasfat_akl/widgets/core/show_image_dialog.dart';
import 'package:get/get.dart';

class DishDescription extends StatelessWidget {
  final String dishDescription;

  const DishDescription({Key? key, required this.dishDescription})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    print('build dish description');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      margin: const EdgeInsets.all(12.0),
      width: size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Html(
        data: dishDescription,
        onImageTap: (imageUrl, _, __, ___) async {
          await showDialog(
            context: Get.context!,
            builder: (context) {
              return ShowImageDialog(
                photoUrl: imageUrl ?? '',
              );
            },
          );
        },
        style: {
          "h2": Style(
              textAlign: TextAlign.right,
              direction: TextDirection.rtl,
              color: Colors.red),
          "p": Style(
            direction: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        },
      ),
    );
  }
}
