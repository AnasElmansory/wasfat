import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';
import 'package:wasfat_akl/widgets/category_widgets/category_grid_tile.dart';

class TopCategories extends StatelessWidget {
  const TopCategories();
  @override
  Widget build(BuildContext context) {
    print('building TopCategories');
    final foodProvider = context.watch<FoodCategoryProvider>();
    final size = context.mediaQuerySize;
    final categorySize = Size.square(size.width * 0.5);
    return GridView.builder(
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final category =
            (index != 3) ? foodProvider.topCategories[index] : null;
        if (index == 3)
          return InkWell(
              onTap: () async => await navigateToMoreCategoriesPage(),
              child: GridTile(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFFA000),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
                      const Text(
                        'المزيد',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        else {
          return InkWell(
            onTap: () async => await navigateToCategoryPage(category!.id),
            child: CategoryGridTile(
              category: category!,
              size: categorySize,
            ),
          );
        }
      },
    );
  }
}
