import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';

class FavouriteListPage extends StatefulWidget {
  const FavouriteListPage();
  @override
  _FavouriteListPageState createState() => _FavouriteListPageState();
}

class _FavouriteListPageState extends State<FavouriteListPage>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shared = context.watch<SharedPreferencesProvider>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاطباق المفضلة'),
      ),
      body: (shared.favouriteDishes.isEmpty)
          ? const Center(child: const Text("لا توجد اطباق مفضله"))
          : ListView.builder(
              itemCount: shared.favouriteDishes.length,
              itemBuilder: (context, index) {
                final dish = shared.favouriteDishes[index];
                return ScaleTransition(
                    scale: _controller,
                    child: GFListTile(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
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
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OneDishPage(
                                    mDish: dish,
                                  )));
                        }));
              },
            ),
    );
  }
}
