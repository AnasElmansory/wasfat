import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';

class SendReviewButton extends StatelessWidget {
  final String dishId;
  final Map<String, int> dishRating;

  const SendReviewButton({
    Key? key,
    required this.dishId,
    required this.dishRating,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * .15,
      ),
      child: GFButton(
        text: 'ارسال',
        textStyle: const TextStyle(fontSize: 18),
        borderShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.amber[700]!,
        icon: const Icon(
          Icons.add_comment_rounded,
          color: Colors.white,
        ),
        onPressed: () async {
          await context.read<DishCommentProvider>().onSendPressed(
                dishId,
                dishRating,
              );
        },
      ),
    );
  }
}
