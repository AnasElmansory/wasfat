import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/widgets/one_card_widget.dart';

class SlideShow extends StatelessWidget {
  const SlideShow();
  @override
  Widget build(BuildContext context) {
    final slider = context.watch<SliderIndicatorProvider>();
    final foodProvider = context.watch<FoodCategoryProvider>();
    final size = MediaQuery.of(context).size;
    return Container(
      child: CarouselSlider.builder(
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          onPageChanged: (index, reason) => slider.current = index,
        ),
        itemCount: foodProvider.dishesRecentlyAdded.length,
        itemBuilder: (context, index) => InkWell(
          child: OneCardWidget(
            name: foodProvider.dishesRecentlyAdded[index].name,
            imageUrl: foodProvider.dishesRecentlyAdded[index].dishImages.first,
            size: Size(size.width * 0.8, size.height * 0.25),
            textColor: Colors.white,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OneDishPage(
                  dish: foodProvider.dishesRecentlyAdded[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
