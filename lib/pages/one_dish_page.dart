import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/ads/native_ad_widget.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/core/show_image_dialog.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_custom_bar.dart';
import 'package:wasfat_akl/widgets/dish_widgets/rating_bar.dart';
import 'package:wasfat_akl/widgets/dish_widgets/top_two_comment.dart';

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
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
    final commentProvider = context.read<DishCommentProvider>();
    final dishesProvider = context.read<DishesProvider>();
    commentProvider.initialRateValue(dish.rating);
    commentProvider.listenToTopTwoComments(dish.id);
    dishesProvider.listenDishLikes(dish.id);
    dishesProvider.handlefavouriteFabButton(_animationController);
    context.read<DishesPreferencesProvider>().setLastVisitedDish(dish);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final dishesProvider = context.watch<DishesProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BannerWrapList(
              listType: ListType.Sliver,
              controller: dishesProvider.scrollController,
              pageWidgets: [
                DishCustomBar(dish: dish),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _subtitle(dish.subtitle),
                    Container(
                      constraints: BoxConstraints.loose(Size(size.width, 150)),
                      child: const NativeAdWidget(),
                    ),
                    _dishDescription(dish, size),
                    const DividerWidget(dividerName: "أضف تقييم", marginTop: 2),
                    _commentTextField(_controller, size),
                    const RatingBarWidget(),
                    const SizedBox(height: 20.0),
                    Container(
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
                          final commentProvider =
                              context.read<DishCommentProvider>();
                          await commentProvider.onSendPressed(
                            _controller.text,
                            dish.id,
                            dish.rating,
                          );
                          _controller.clear();
                        },
                      ),
                    ),
                    TopTwoComments(dish: dish),
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

Widget _dishDescription(Dish dish, Size size) {
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

Widget _commentTextField(TextEditingController controller, Size size) {
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

Widget _customFAB(Animation<double> animation, Dish dish) {
  final shared = Get.context!.watch<DishesPreferencesProvider>();
  return Positioned(
    bottom: 60,
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
