import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';

class CommentTextField extends StatelessWidget {
  const CommentTextField();

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;

    final controller = context.read<DishCommentProvider>().controller;
    return Container(
      width: size.width * 0.8,
      height: size.height * .2,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: const Border(
          top: const BorderSide(color: Colors.grey),
          bottom: const BorderSide(color: Colors.grey),
          right: const BorderSide(color: Colors.grey),
          left: const BorderSide(color: Colors.grey),
        ),
        borderRadius: const BorderRadius.all(const Radius.circular(10)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'أضف تعليق',
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLines: null,
      ),
    );
  }
}
