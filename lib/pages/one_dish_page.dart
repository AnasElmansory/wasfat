import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/cached_image.dart';
import 'package:wasfat_akl/widgets/core/confirmation_dialog.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/dish_custom_bar.dart';
import 'package:wasfat_akl/widgets/one_comment_widget.dart';
import 'package:wasfat_akl/widgets/show_image_dialog.dart';

class OneDishPage extends StatefulWidget {
  final Dish dish;

  const OneDishPage({Key? key, required this.dish}) : super(key: key);

  @override
  _OneDishPageState createState() => _OneDishPageState();
}

class _OneDishPageState extends State<OneDishPage>
    with SingleTickerProviderStateMixin {
  Dish get dish => widget.dish;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
    context.read<DishCommentProvider>().initialRateValue(dish.rating);
    context.read<DishesProvider>().listenDishLikes(dish.id);
    context.read<DishCommentProvider>().listenToTopTwoComments(dish.id);
    context.read<DishesPreferencesProvider>().setLastVisitedDish(dish);
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          _animationController.forward();
          break;
        case ScrollDirection.reverse:
          _animationController.reverse();
          break;
        case ScrollDirection.idle:
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final auth = context.watch<Auth>();
    final commentProvider = context.watch<DishCommentProvider>();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                DishCustomBar(dish: dish),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _subtitle(dish.subtitle),
                    _dishDescription(dish),
                    const DividerWidget(dividerName: "أضف تقييم", marginTop: 2),
                    _commentTextField(_controller),
                    _ratingBar(),
                    const SizedBox(height: 20.0),
                    MaterialButton(
                        onPressed: () async {
                          await commentProvider.onSendPressed(
                            _controller.text,
                            dish.id,
                            dish.rating,
                          );
                          _controller.clear();
                        },
                        minWidth: size.width * 0.7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 2.0,
                        textColor: Colors.white,
                        color: Colors.amber[700],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('ارسال',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 20.0),
                            const Icon(Icons.add_comment_rounded),
                          ],
                        )),
                    _topTwoComments(commentProvider, auth, dish),
                  ]),
                ),
              ],
            ),
          ),
          _customFAB(_animationController.view, dish),
        ],
      ),
    );
  }
}

Widget _subtitle(String? subtitle) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
    margin: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10)),
    child: Text(
      subtitle ?? '',
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    ),
  );
}

Widget _dishDescription(Dish dish) {
  final size = Get.context!.mediaQuerySize;
  final category = Get.context!
      .watch<FoodCategoryProvider>()
      .getCategory(dish.categoryId.first);
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
      data: dish.dishDescription,
      onImageTap: (imageUrl, _, __, ___) async {
        await showDialog(
          context: Get.context!,
          builder: (context) {
            return ShowImageDialog(photoUrl: imageUrl ?? '');
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

Widget _commentTextField(TextEditingController controller) {
  final size = Get.context!.mediaQuerySize;
  return Container(
    width: size.width * 0.8,
    height: size.height * .2,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    margin: EdgeInsets.all(12.0),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10)),
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

Widget _ratingBar() {
  final size = Get.context!.mediaQuerySize;
  final commentProvider = Get.context!.watch<DishCommentProvider>();
  return Container(
    margin: const EdgeInsets.all(12.0),
    width: size.width,
    child: Column(
      children: [
        RatingBar.builder(
          initialRating: commentProvider.getRateValue.toDouble(),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: const Color(0xFFFFA000),
          ),
          onRatingUpdate: (rating) =>
              commentProvider.setRateValue = rating.floor(),
        ),
      ],
    ),
  );
}

Widget _customFAB(Animation<double> animation, Dish dish) {
  final shared = Get.context!.watch<DishesPreferencesProvider>();
  return Positioned(
    bottom: 16,
    right: 0,
    child: FadeTransition(
      opacity: animation,
      child: RotationTransition(
        turns: animation,
        child: MaterialButton(
          padding: const EdgeInsets.all(12),
          child: shared.favouriteDishes.contains(dish)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                )
              : const Icon(
                  Icons.favorite,
                  color: Colors.white70,
                  size: 30,
                ),
          onPressed: () async => shared.favouriteDishes.contains(dish)
              ? await shared.removeFavouriteDish(dish)
              : await shared.addFavouriteDish(dish),
          color: const Color(0xFFFF8F00),
          shape: const CircleBorder(),
        ),
      ),
    ),
  );
}

Widget _topTwoComments(
  DishCommentProvider commentProvider,
  Auth auth,
  Dish dish,
) {
  final ifNoComment = commentProvider.comments.isEmpty;
  // final size = Get.context!.mediaQuerySize;
  return Container(
    // height: size.height * .4,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ifNoComment
        ? const Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: const Text(
              'لا توجد تعليقات',
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            children: commentProvider.comments.map<Widget>((comment) {
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
          }).toList()),
  );
}
