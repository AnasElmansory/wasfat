import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/slider_indicator_provider.dart';

class SlideShowIndicator extends StatelessWidget {
  const SlideShowIndicator();
  @override
  Widget build(BuildContext context) {
    final dishesProvider = context.watch<DishesProvider>();
    final slider = context.watch<SliderIndicatorProvider>();
    final recentDishes = dishesProvider.recentlyAddedDishes;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: recentDishes.map<Widget>((_) {
          final index = recentDishes.indexOf(_);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.only(
              top: 2.0,
              bottom: 10.0,
              left: 2.0,
              right: 2.0,
            ),
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
