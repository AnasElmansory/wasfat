import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';

class SlideShowIndicator extends StatelessWidget {
  const SlideShowIndicator();
  @override
  Widget build(BuildContext context) {
    final foodProvider = context.watch<FoodCategoryProvider>();
    final slider = context.watch<SliderIndicatorProvider>();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: foodProvider.dishesRecentlyAdded.map<Widget>((_) {
          final index = foodProvider.dishesRecentlyAdded.indexOf(_);
          return Container(
            width: 8.0,
            height: 8.0,
            margin:
                EdgeInsets.only(top: 2.0, bottom: 10.0, left: 2.0, right: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  slider.current == index ? Colors.amber[700] : Colors.black54,
            ),
          );
        }).toList(),
      ),
    );
  }
}
