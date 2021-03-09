import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/providers/search_provider.dart';

class WasfatSearchAppBar extends StatefulWidget {
  const WasfatSearchAppBar({Key key}) : super(key: key);

  @override
  _WasfatSearchAppBarState createState() => _WasfatSearchAppBarState();
}

class _WasfatSearchAppBarState extends State<WasfatSearchAppBar> {
  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();
    final size = MediaQuery.of(context).size;
    return SearchAppBarPage<Dish>(
      //initialData: _initialData,
      magnifyinGlassColor: Colors.white,
      searchAppBarcenterTitle: true,
      searchAppBarhintText: 'ابحث عن وصفه',
      searchAppBartitle: Text(
        'ابحث عن وصفه',
        style: const TextStyle(fontSize: 20),
      ),
      listFull: search.results,
      stringFilter: (Dish dish) => dish.name,
      //compare: false,
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive verables into it.
        if (search.isSearching)
          return const Center(
            child: const SpinKitThreeBounce(
              size: 30,
              color: const Color(0xFFFFA800),
            ),
          );
        if (search.results.isEmpty)
          return const Center(
            child: const Text(
              'لا توجد نتائج',
              textDirection: TextDirection.rtl,
            ),
          );
        return Container(
          // height: size.height - (kToolbarHeight + statusBar),
          child: ListView.builder(
            itemCount: search.results.length,
            itemBuilder: (context, index) {
              return GFListTile(
                  margin: const EdgeInsets.all(0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      search.results[index].name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    search.results[index].subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  icon: Container(
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                      child: CachedNetworkImage(
                        imageUrl: search.results[index].dishImages.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ImageIcon(
                          const AssetImage('assets/transparent_logo.ico'),
                          color: const Color(0xFFF5F5F5),
                          size: 30,
                        ),
                      )),
                  onTap: () async =>
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              OneDishPage(dish: search.results[index]),
                        ),
                      ));
            },
          ),
        );
      },
    );
  }
}
