import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info/package_info.dart';
import 'package:wasfat_akl/helper/internet_helper.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/providers/dish_actions_provider.dart';
import 'package:wasfat_akl/providers/dish_likes_provider.dart';
import 'package:wasfat_akl/providers/food_category_provider.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerFactory<FoodCategoryProvider>(() => FoodCategoryProvider(
        getIt<FirebaseFirestore>(),
        getIt<InternetHelper>(),
      ));
  getIt.registerFactory<SharedPreferencesProvider>(
      () => SharedPreferencesProvider()..sharedInstance);
  getIt.registerFactory<DishProvider>(
      () => DishProvider(getIt<FirebaseFirestore>()));
  getIt.registerFactory<DishLikesProvider>(
      () => DishLikesProvider(getIt<FirebaseFirestore>()));

  getIt.registerFactory<Auth>(
    () => Auth(
      getIt<GoogleSignIn>(),
      getIt<FacebookAuth>(),
      getIt<FirebaseAuth>(),
      getIt<FirebaseFirestore>(),
      getIt<DataConnectionChecker>(),
    ),
  );

  getIt.registerLazySingleton<InternetHelper>(
      () => InternetHelper(getIt<DataConnectionChecker>()));
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());

  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.standard());
  getIt.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  getIt.registerSingletonAsync<PackageInfo>(
      () async => await PackageInfo.fromPlatform());

  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
}
