import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/pages/food_category_page.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/widgets/one_card_widget.dart';

class MoreCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<FoodCategoryProvider>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('كل الأقسام'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: ((size.width * 0.5) / (size.height * 0.2))),
        itemCount: categoryProvider.foodCategories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FoodCategoryPage(
                        foodCategoryId: categoryProvider.foodCategories.values
                            .toList()[index]
                            .id,
                      )));
            },
            child: Container(
              width: size.width * 0.5,
              height: size.height * 0.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(10)),
                child: OneCardWidget(
                  name: categoryProvider.foodCategories.values
                      .toList()[index]
                      .name,
                  imageUrl: categoryProvider.foodCategories.values
                      .toList()[index]
                      .imageUrl,
                  size: Size(size.width * 0.5, size.height * 0.2),
                  textColor: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
