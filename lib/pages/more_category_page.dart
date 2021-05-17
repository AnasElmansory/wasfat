import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/category_widgets/category_grid_tile.dart';

class MoreCategoryPage extends StatelessWidget {
  const MoreCategoryPage();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final size = context.mediaQuerySize;
    final categorySize = Size.square(size.width * .5);
    return Scaffold(
      appBar: AppBar(title: const Text('كل الأقسام')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
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
              child: CategoryGridTile(
                category: category,
                size: categorySize,
              ),
            );
          },
        ),
      ),
    );
  }
}
