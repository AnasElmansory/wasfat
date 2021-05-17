import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';
import 'package:wasfat_akl/firebase/categories_service.dart';
import 'package:wasfat_akl/firebase/comment_service.dart';
import 'package:wasfat_akl/firebase/dishes_service.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_comments_provider.dart';
import 'package:wasfat_akl/providers/dishes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/dishes_preferences.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerFactory<FoodCategoryProvider>(() => FoodCategoryProvider(
        getIt<CategoriesService>(),
      ));
  getIt.registerFactory<AdmobProvider>(() => AdmobProvider());

  getIt.registerFactory<DishesProvider>(
      () => DishesProvider(getIt<DishesService>()));

  getIt.registerFactory<DishesPreferencesProvider>(
      () => DishesPreferencesProvider());

  getIt.registerFactory<DishCommentProvider>(() => DishCommentProvider(
        getIt<CommentService>(),
      ));

  getIt.registerFactory<Auth>(
    () => Auth(
      getIt<GoogleSignIn>(),
      getIt<FacebookAuth>(),
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<CategoriesService>(
      () => CategoriesService(getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton<DishesService>(
      () => DishesService(getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton<CommentService>(
      () => CommentService(getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.standard());
  getIt.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  getIt.registerSingletonAsync<PackageInfo>(
      () async => await PackageInfo.fromPlatform());

  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
}
