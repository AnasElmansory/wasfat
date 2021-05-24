import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/core/one_card_widget.dart';

class SlideShow extends StatelessWidget {
  const SlideShow();
  @override
  Widget build(BuildContext context) {
    print('building SlideShow');
    final slider = context.watch<SliderIndicatorProvider>();
    final dishesProvider = context.watch<DishesProvider>();
    final size = context.mediaQuerySize;

    return Container(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          onPageChanged: (index, reason) => slider.current = index,
        ),
        itemCount: dishesProvider.recentlyAddedDishes.length,
        itemBuilder: (context, index, _) {
          final dish = dishesProvider.recentlyAddedDishes[index];
          return InkWell(
            child: OneCardWidget(
              name: dish.name,
              imageUrl: dish.dishImages?.first ?? '',
              size: Size(size.width * 0.8, size.height * 0.3),
              textColor: Colors.white,
            ),
            onTap: () async => await navigateToOneDishPage(dish),
          );
        },
      ),
    );
  }
}
