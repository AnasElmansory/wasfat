import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:wasfat_akl/widgets/show_image_dialog.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DishCustomBar extends StatefulWidget {
  final Dish dish;

  const DishCustomBar({Key key, this.dish}) : super(key: key);

  @override
  _DishCustomBarState createState() => _DishCustomBarState();
}

class _DishCustomBarState extends State<DishCustomBar> {
  double _barHeight = 0.0;
  Dish get _dish => widget.dish;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<Auth>();
    final dishProvider = context.watch<DishProvider>();
    return SliverAppBar(
      backgroundColor:
          (_barHeight == (kToolbarHeight + MediaQuery.of(context).padding.top))
              ? Colors.amber[700]
              : (_barHeight < 90)
                  ? Colors.amber[500]
                  : (_barHeight < 120)
                      ? Colors.amber[300]
                      : Colors.white70,
      expandedHeight: size.height * 0.3,
      title: Text(
        (_barHeight == (kToolbarHeight + MediaQuery.of(context).padding.top))
            ? _dish.name
            : '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      pinned: true,
      stretch: true,
      flexibleSpace: InkWell(
        onTap: () async => await showDialog(
          context: context,
          builder: (_) => ShowImageDialog(
            photoUrl: _dish.dishImages.first,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
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
                    child: CachedNetworkImage(
                      imageUrl: _dish.dishImages.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const ImageIcon(
                        const AssetImage('assets/transparent_logo.ico'),
                        color: const Color(0xFFF5F5F5),
                        size: 30,
                      ),
                    ),
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
                                color: dishProvider.isLiked(auth.userId)
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () async =>
                                  await dishProvider.likeDish(
                                auth.userId,
                                auth,
                                context,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(intl.NumberFormat.compact().format(
                              dishProvider.dish.likesCount ?? 0,
                            )),
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
                                  dishProvider.getOneDishRating().toString(),
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
                                    _dish.name,
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
