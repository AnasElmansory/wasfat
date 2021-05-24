import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wasfat_akl/providers/dish_likes_provider.dart';
import 'package:wasfat_akl/widgets/core/cached_image.dart';
import 'package:wasfat_akl/widgets/core/show_image_dialog.dart';
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
  Dish get dish => widget.dish;

  @override
  Widget build(BuildContext context) {
    final dishLikesProvider = context.watch<DishLikesProvider>();
    final auth = context.watch<Auth>();
    final size = context.mediaQuerySize;
    final dishLikes = dishLikesProvider.dishesLikes[dish.id];
    final dishLikesCount = dishLikes?.length ?? 0;
    final expandedHeight = size.height * .3;
    final imageBottomMargin = 24.0;
    final isLiked = dishLikes?.contains(auth.wasfatUser?.uid ?? '') ?? false;

    return SliverLayoutBuilder(
      builder: (BuildContext context, SliverConstraints constraints) {
        final height = constraints.scrollOffset;
        final isExpanded = height <= (expandedHeight * 0.5);
        final bar = isExpanded
            ? const HideDishTitle()
            : ShowDishTitle(dishName: dish.name);
        return SliverAppBar(
          backgroundColor:
              isExpanded ? Colors.white : Colors.amber[800],
          expandedHeight: expandedHeight,
          title: bar,
          pinned: true,
          stretch: true,
          onStretchTrigger: () async {
            print('stretced');
          },
          flexibleSpace: InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return ShowImageDialog(
                    photoUrl: dish.dishImages?.first ?? '',
                  );
                },
              );
            },
            child: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    bottom: imageBottomMargin,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: const Radius.circular(100),
                      ),
                      child: CachedImage(url: dish.dishImages?.first ?? ''),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      height: 48,
                      width: size.width * 0.3,
                      child: Container(
                        width: size.width * .3,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: isLiked ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () async {
                                if (isLiked)
                                  await dishLikesProvider.unlikeDish(dish.id);
                                else
                                  await dishLikesProvider.likeDish(dish.id);
                              },
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              intl.NumberFormat.compact()
                                  .format(dishLikesCount),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    height: 48,
                    child: Container(
                      constraints: BoxConstraints.loose(
                        Size(size.width * .7, 48),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: const Radius.circular(30),
                            bottomLeft: const Radius.circular(30)),
                        color: const Color(0xFFFFA000),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
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
                          Flexible(
                            child: AutoSizeText(
                              dish.name,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String _getRatingValue(Map<String, int>? rating) {
  if (rating?.isEmpty ?? true) return '0';
  final sum = rating!.values.reduce((valueF, valueL) => valueF + valueL);
  final average = (sum / rating.values.length).toPrecision(1);
  return average.toString();
}

class HideDishTitle extends StatelessWidget {
  const HideDishTitle();
  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}

class ShowDishTitle extends StatelessWidget {
  final String dishName;

  const ShowDishTitle({Key? key, required this.dishName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      dishName,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
