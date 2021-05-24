import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/firebase/dishes_service.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class DishLikesProvider extends ChangeNotifier {
  final DishesService _dishesService;

  DishLikesProvider(this._dishesService);
  StreamSubscription<List<String>>? _likesSubscription;
  Map<String, List<String>> _dishesLikes = Map();
  Map<String, List<String>> get dishesLikes => this._dishesLikes;
  Future<void> listenDishLikes(String dishId) async {
    await _likesSubscription?.cancel();
    _likesSubscription = null;
    _likesSubscription = _dishesService.listenDishLikes(dishId).listen((likes) {
      dishesLikes[dishId] = likes;
      notifyListeners();
    });
  }

  Future<void> isAuthenticated() async {
    final auth = Get.context!.read<Auth>();
    if (!await auth.isLoggedIn()) return await navigateToSignPageUntil();
  }

  Future<void> likeDish(String dishId) async {
    await isAuthenticated();
    await _dishesService.likeDish(dishId);
  }

  Future<void> unlikeDish(String dishId) async {
    await isAuthenticated();
    await _dishesService.unlikeDish(dishId);
  }

  @override
  void dispose() {
    _likesSubscription?.cancel();
    super.dispose();
  }
}
