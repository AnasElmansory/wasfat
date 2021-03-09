import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';

import '../core/confirmation_dialog.dart';
import '../one_card_widget.dart';

class LastVisitedList extends HookWidget {
  const LastVisitedList();
  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(duration: kTabScrollDuration)
      ..forward();
    final size = MediaQuery.of(context).size;
    final shared = context.watch<SharedPreferencesProvider>();
    return Container(
      height: size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shared.lastVisitedDishes.length,
        itemBuilder: (context, index) {
          return ScaleTransition(
            scale: animation,
            child: InkWell(
              onTap: () async => await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OneDishPage(
                    dish: shared.lastVisitedDishes[index],
                  ),
                ),
              ),
              onLongPress: () async => await showDialog<bool>(
                barrierDismissible: false,
                context: context,
                builder: (context) => confirmationDialog(
                  '.قائمه الأطباق المفضلة',
                  '.هل تريد ازاله هذا الطبق من القائمة',
                  true,
                  context,
                ),
              ).then((value) async {
                if (value)
                  await shared
                      .removeLastVisitedDish(shared.lastVisitedDishes[index]);
              }),
              child: OneCardWidget(
                name: shared.lastVisitedDishes[index].name,
                imageUrl: shared.lastVisitedDishes[index].dishImages.first,
                size: Size(size.width * 0.5, size.height * 0.2),
                textColor: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
