import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';

import '../core/confirmation_dialog.dart';
import '../one_card_widget.dart';

class FavList extends HookWidget {
  final bool isInHome;

  const FavList({Key key, this.isInHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = useAnimationController(duration: kTabScrollDuration)
      ..forward();
    final size = MediaQuery.of(context).size;
    final shared = context.watch<SharedPreferencesProvider>();
    return Container(
      height: isInHome ? size.height * 0.2 : size.height,
      child: ListView.builder(
        scrollDirection: isInHome ? Axis.horizontal : Axis.vertical,
        itemCount: shared.favouriteDishes.length,
        itemBuilder: (context, index) {
          return ScaleTransition(
            scale: animation,
            child: isInHome
                ? InkWell(
                    onTap: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OneDishPage(
                          dish: shared.favouriteDishes[index],
                        ),
                      ),
                    ),
                    onLongPress: () async => await showDialog<bool>(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => confirmationDialog(
                        'قائمه الأطباق المفضلة',
                        '.هل تريد ازاله هذا الطبق من القائمة',
                        true,
                        context,
                      ),
                    ).then((value) async {
                      if (value)
                        await shared
                            .removeFavouriteDish(shared.favouriteDishes[index]);
                    }),
                    child: OneCardWidget(
                      name: shared.favouriteDishes[index].name,
                      imageUrl: shared.favouriteDishes[index].dishImages.first,
                      size: Size(size.width * 0.5, size.height * 0.2),
                      textColor: Colors.white,
                    ),
                  )
                : _favPageWidget(
                    animation, shared.favouriteDishes[index], context),
          );
        },
      ),
    );
  }

  Widget _favPageWidget(Animation animation, Dish dish, BuildContext context) {
    final shared = context.watch<SharedPreferencesProvider>();
    final size = MediaQuery.of(context).size;
    return ScaleTransition(
      scale: animation,
      child: GFListTile(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 2,
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            dish.name,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text(
          dish.subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
        ),
        icon: Container(
          height: size.height * 0.2,
          width: size.width * 0.4,
          child: CachedNetworkImage(
            imageUrl: dish.dishImages.first,
            fit: BoxFit.cover,
          ),
        ),
        avatar: IconButton(
            icon: shared.favouriteDishes.contains(dish)
                ? const Icon(
                    Icons.favorite,
                    size: 30,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 30,
                  ),
            onPressed: () async {
              if (shared.favouriteDishes.contains(dish))
                await shared.removeFavouriteDish(dish);
              else
                await shared.addFavouriteDish(dish);
            }),
        onTap: () async => await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OneDishPage(
              dish: dish,
            ),
          ),
        ),
      ),
    );
  }
}
