import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/custom_fab_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/dish_likes_provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/widgets/ads/banner_wrap_list.dart';
import 'package:wasfat_akl/widgets/ads/native_ad_widget.dart';
import 'package:wasfat_akl/widgets/core/divider_widget.dart';
import 'package:wasfat_akl/widgets/dish_widgets/comment_text_field.dart';
import 'package:wasfat_akl/widgets/dish_widgets/custom_fab_button.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_custom_bar.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_description.dart';
import 'package:wasfat_akl/widgets/dish_widgets/dish_subtitle.dart';
import 'package:wasfat_akl/widgets/dish_widgets/rating_bar.dart';
import 'package:wasfat_akl/widgets/dish_widgets/send_review_button.dart';
import 'package:wasfat_akl/widgets/dish_widgets/top_two_comment.dart';

class OneDishPage extends HookWidget {
  final Dish dish;

  const OneDishPage({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build one dish page');
    final size = context.mediaQuerySize;
    final animation = useAnimationController(duration: kTabScrollDuration);
    onDishOpend(context);
    return ChangeNotifierProvider(
      create: (_) => CustomFabProvider(),
      builder: (context, child) {
        final fabProvider = context.watch<CustomFabProvider>();
        final controller = fabProvider.handlefavouriteFabButton(animation);
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: BannerWrapList(
                  listType: ListType.Sliver,
                  controller: controller,
                  pageWidgets: [
                    DishCustomBar(dish: dish),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        DishSubtitle(subtitle: dish.subtitle ?? ''),
                        Container(
                          constraints:
                              BoxConstraints.loose(Size(size.width, 150)),
                          child: const NativeAdWidget(),
                        ),
                        DishDescription(dishDescription: dish.dishDescription),
                        const DividerWidget(
                          dividerName: "أضف تقييم",
                          marginTop: 2,
                        ),
                        const CommentTextField(),
                        const RatingBarWidget(),
                        const SizedBox(height: 20.0),
                        SendReviewButton(
                          dishId: dish.id,
                          dishRating: dish.rating,
                        ),
                        TopTwoComments(dish: dish),
                      ]),
                    ),
                  ],
                ),
              ),
              CustomFabButton(dish, animation),
            ],
          ),
        );
      },
    );
  }

  void onDishOpend(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final commentProvider = context.read<DishCommentProvider>();
      final dishLikesProvider = context.read<DishLikesProvider>();
      commentProvider.initialRateValue(dish.rating);
      commentProvider.listenToTopTwoComments(dish.id);
      dishLikesProvider.listenDishLikes(dish.id);
      context.read<DishesPreferencesProvider>().setLastVisitedDish(dish);
    });
  }
}
