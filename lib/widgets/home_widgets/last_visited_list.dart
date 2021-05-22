import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';
import 'package:wasfat_akl/utils/navigation.dart';

import '../core/confirmation_dialog.dart';
import '../core/one_card_widget.dart';

class LastVisitedList extends HookWidget {
  const LastVisitedList();
  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(duration: kTabScrollDuration)
      ..forward();
    final size = context.mediaQuerySize;
    final preferences = context.watch<DishesPreferencesProvider>();
    return Container(
      height: size.height * 0.25,
      padding: const EdgeInsets.only(bottom: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: preferences.lastVisitedDishes.length,
        itemBuilder: (context, index) {
          final dish = preferences.lastVisitedDishes[index];

          return ScaleTransition(
            scale: animation,
            child: InkWell(
              onTap: () async => await navigateToOneDishPage(dish),
              onLongPress: () async {
                final result = await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => confirmationDialog(
                    '.قائمه الأطباق المفضلة',
                    '.هل تريد ازاله هذا الطبق من القائمة',
                    true,
                    context,
                  ),
                );
                if (result ?? false)
                  await preferences.removeLastVisitedDish(dish);
              },
              child: OneCardWidget(
                name: dish.name,
                imageUrl: dish.dishImages?.first ?? '',
                size: Size(size.width * 0.5, size.height * 0.25),
                textColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
