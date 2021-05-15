import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/widgets/cached_image.dart';
import 'package:wasfat_akl/widgets/show_image_dialog.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DishCustomBar extends StatefulWidget {
  final Dish dish;

  const DishCustomBar({Key? key, required this.dish}) : super(key: key);

  @override
  _DishCustomBarState createState() => _DishCustomBarState();
}

class _DishCustomBarState extends State<DishCustomBar> {
  double _barHeight = 0.0;
  Dish get dish => widget.dish;

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final dishesProvider = context.watch<DishesProvider>();
    final auth = context.watch<Auth>();
    final padding = context.mediaQueryPadding;
    final size = context.mediaQuerySize;
    final category = categoryProvider.getCategory(dish.categoryId.first);
    final dishLikes = dishesProvider.oneDishLikes;
    final dishLikesCount = dishLikes.length;
    final isLiked = dishLikes.contains(auth.wasfatUser?.uid ?? '');
    return SliverAppBar(
      backgroundColor: (_barHeight == (kToolbarHeight + padding.top))
          ? Colors.amber[700]
          : (_barHeight < 90)
          ? Colors.amber[500]
          : (_barHeight < 120)
          ? Colors.amber[300]
          : Colors.white70,
      expandedHeight: size.height * 0.3,
      title: AutoSizeText(
        (_barHeight == (kToolbarHeight + padding.top)) ? dish.name : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      pinned: true,
      stretch: true,
      flexibleSpace: InkWell(
        onTap: () async => await showDialog(
          context: context,
          builder: (_) {
            return ShowImageDialog(
              photoUrl: dish.dishImages?.first ?? '',
            );
          },
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) =>
                setState(() => _barHeight = constraints.biggest.height));
            return FlexibleSpaceBar(
              background: Stack(children: [
                Positioned(
                  width: size.width,
                  height: size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: const Radius.circular(100),
                    ),
                    child: CachedImage(url: dish.dishImages?.first ?? ''),
                  ),
                ),
                Positioned(
                  height: size.height * 0.06,
                  width: size.width,
                  bottom: 0,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: isLiked ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () async {
                                if (isLiked)
                                  await dishesProvider.unlikeDish(dish.id);
                                else
                                  await dishesProvider.likeDish(dish.id);
                              },
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              intl.NumberFormat.compact()
                                  .format(dishLikesCount),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(30),
                                bottomLeft: const Radius.circular(30)),
                            color: const Color(0xFFFFA000),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  _getRatingValue(dish.rating),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.star,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    dish.name,
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

String _getRatingValue(Map<String, int>? rating) {
  if (rating?.isEmpty ?? true) return '0';
  final sum = rating!.values.reduce((valueF, valueL) => valueF + valueL);
  final average = (sum / rating.values.length).toPrecision(1);
  return average.toString();
}
