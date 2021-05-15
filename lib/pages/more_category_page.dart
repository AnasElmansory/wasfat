import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/cached_image.dart';

class MoreCategoryPage extends StatelessWidget {
  const MoreCategoryPage();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<FoodCategoryProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('كل الأقسام')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.categories[index];
          return InkWell(
            onTap: () async => await navigateToCategoryPage(category.id),
            child: GridTile(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
                child: CachedImage(url: category.imageUrl),
              ),
              footer: GridTileBar(
                title: Text(category.name),
              ),
            ),
          );
        },
      ),
    );
  }
}
