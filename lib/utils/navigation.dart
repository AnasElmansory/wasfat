import 'package:get/get.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/pages/favourite_dishlist_page.dart';
import 'package:wasfat_akl/pages/food_category_page.dart';
import 'package:wasfat_akl/pages/home_page.dart';
import 'package:wasfat_akl/pages/more_category_page.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/pages/privacy_page.dart';
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/pages/terms_condition_page.dart';

Future<void> navigateToHomePage() async {
  await Get.off(() => const HomePage());
}

Future<void> navigateToSignPage() async {
  await Get.off(() => const SignInPage());
}

Future<void> navigateToSignPageUntil() async {
  await Get.to(const SignInPage());
}

Future<void> navigateToTermsAndConditions() async {
  await Get.off(() => const TermsAndConditionPage());
}

Future<void> navigateToPrivacyPage() async {
  await Get.to(const PrivacyPage());
}

Future<void> navigateToFavouriteListPage() async {
  await Get.to(const FavouriteListPage());
}

Future<void> navigateToMoreCategoriesPage() async {
  await Get.to(const MoreCategoryPage());
}

Future<void> navigateToCategoryPage(String categoryId) async {
  await Get.to(FoodCategoryPage(foodCategoryId: categoryId));
}

Future<void> navigateToOneDishPage(Dish dish) async {
  await Get.to(OneDishPage(dish: dish));
}
