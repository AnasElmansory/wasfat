import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/search_provider.dart';

class SearchFilterDialog extends StatelessWidget {
  const SearchFilterDialog();
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final searchProvider = context.watch<SearchProvider>();
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          children: categoryProvider.categories.map<Widget>(
            (category) {
              final isSelected = searchProvider.isSelected(category);
              return GFListTile(
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    category.name,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                onTap: () => searchProvider.filterCategory(category),
                selected: isSelected,
                color: isSelected ? Colors.black12 : GFColors.TRANSPARENT,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
