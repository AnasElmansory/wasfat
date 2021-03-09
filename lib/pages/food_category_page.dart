import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:wasfat_akl/widgets/category_custom_bar.dart';

import 'one_dish_page.dart';

class FoodCategoryPage extends StatefulWidget {
  final String foodCategoryId;

  const FoodCategoryPage({Key key, this.foodCategoryId}) : super(key: key);

  @override
  _FoodCategoryPageState createState() => _FoodCategoryPageState();
}

class _FoodCategoryPageState extends State<FoodCategoryPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    context
        .read<FoodCategoryProvider>()
        .getDishesByCategory(widget.foodCategoryId);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shared = context.watch<SharedPreferencesProvider>();
    final category = context
        .watch<FoodCategoryProvider>()
        .foodCategories[widget.foodCategoryId];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CategoryCustomBar(category: category),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (category.dishes == null)
                  return Container(
                    height: size.height,
                    child: Center(
                      child: SpinKitThreeBounce(
                        size: 30,
                        color: Colors.amber[700],
                      ),
                    ),
                  );
                if (category.dishes?.isEmpty ?? false)
                  return const Center(
                    child: const Text(
                      'لا توجد اطباق',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                return ScaleTransition(
                  scale: _controller,
                  child: GFListTile(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 2,
                    ),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        category.dishes[index].name,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      category.dishes[index].subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                    icon: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: category.dishes[index].dishImages.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                    avatar: IconButton(
                        icon: shared.favouriteDishes
                                .contains(category.dishes[index])
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
                          if (shared.favouriteDishes
                              .contains(category.dishes[index]))
                            await shared
                                .removeFavouriteDish(category.dishes[index]);
                          else
                            await shared
                                .addFavouriteDish(category.dishes[index]);
                        }),
                    onTap: () async => await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OneDishPage(
                          dish: category.dishes[index],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: category.dishes?.length ?? 1,
            ),
          ),
        ],
      ),
    );
  }
}
