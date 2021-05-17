import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/pages/comment_page.dart';
import 'package:wasfat_akl/pages/favourite_dishlist_page.dart';
import 'package:wasfat_akl/pages/food_category_page.dart';
import 'package:wasfat_akl/pages/home_page.dart';
import 'package:wasfat_akl/pages/more_category_page.dart';
import 'package:wasfat_akl/pages/one_dish_page.dart';
import 'package:wasfat_akl/pages/privacy_page.dart';
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/pages/terms_condition_page.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';

Future<void> navigateToHomePage() async {
  await Get.off(() => const HomePage());
}

Future<void> navigateToSignPage() async {
  await Get.off(() => const SignInPage());
}

Future<void> navigateToSignPageUntil() async {
  userHasNavigate();
  await Get.to(() => const SignInPage());
}

Future<void> navigateToTermsAndConditions() async {
  await Get.off(() => const TermsAndConditionPage());
}

Future<void> navigateToPrivacyPage() async {
  userHasNavigate();
  await Get.to(() => const PrivacyPage());
}

Future<void> navigateToFavouriteListPage() async {
  userHasNavigate();
  await Get.to(() => const FavouriteListPage());
}

Future<void> navigateToMoreCategoriesPage() async {
  userHasNavigate();
  await Get.to(() => const MoreCategoryPage());
}

Future<void> navigateToCategoryPage(String categoryId) async {
  userHasNavigate();
  await Get.to(() => FoodCategoryPage(foodCategoryId: categoryId));
}

Future<void> navigateToOneDishPage(Dish dish) async {
  userHasNavigate();
  await Get.to(() => OneDishPage(dish: dish));
}

Future<void> navigateToAllCommentPage(Dish dish) async {
  userHasNavigate();
  await Get.to(() => CommentPage(dish: dish));
}

void userHasNavigate() {
  final admobProvider = Get.context!.read<AdmobProvider>();
  admobProvider.userNavigate();
}
