import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';

class CustomFabButton extends StatelessWidget {
  final Dish dish;
  final Animation<double> animation;
  const CustomFabButton(this.dish, this.animation);

  @override
  Widget build(BuildContext context) {
    final shared = context.watch<DishesPreferencesProvider>();

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
}
