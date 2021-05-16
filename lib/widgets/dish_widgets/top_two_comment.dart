import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/core/confirmation_dialog.dart';
import 'package:wasfat_akl/widgets/dish_widgets/one_comment_widget.dart';

class TopTwoComments extends StatelessWidget {
  final Dish dish;

  const TopTwoComments({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<DishCommentProvider>();
    final auth = context.watch<Auth>();
    final ifNoComment = commentProvider.topTwoComments.isEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: [
        ifNoComment
            ? const Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: const Text(
                  'لا توجد تعليقات',
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: commentProvider.topTwoComments.map<Widget>(
                  (comment) {
                    return InkWell(
                      onLongPress: (auth.wasfatUser?.uid != comment.ownerId)
                          ? null
                          : () async {
                              if (!await auth.isLoggedIn())
                                return await navigateToSignPage();
                              final result = await showDialog<bool>(
                                context: Get.context!,
                                builder: (context) => confirmationDialog(
                                  "مسح التعليق",
                                  "هل تريد حقا مسح هذا التعليق",
                                  true,
                                  context,
                                ),
                              );
                              if (result != null && result)
                                await commentProvider.deleteComment(comment.id);
                            },
                      child: OneCommentWidget(
                        dish: dish,
                        comment: comment,
                      ),
                    );
                  },
                ).toList(),
              ),
        if (!ifNoComment) _allComment(dish),
      ]),
    );
  }
}

Widget _allComment(Dish dish) {
  return InkWell(
    onTap: () async => await navigateToAllCommentPage(dish),
    child: const Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: const Text(
        'شاهد كل التعليقات',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: const Color(0xFF00695c),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  );
}
