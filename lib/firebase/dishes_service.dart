import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';

class DishesService {
  final FirebaseFirestore _firestore;

  DishesService(this._firestore);

  Future<List<Dish>> getDishesRecentlyAdded(List<String> categoriesId) async {
    List<Dish> dishes = [];
    if (categoriesId.isNotEmpty) {
      Future<Dish> getOneDishFromCategory(String categoryId) async {
        final query = await _firestore
            .collection('dishes')
            .orderBy('addDate', descending: true)
            .where('categoryId', arrayContains: categoryId)
            .limit(1)
            .get();
        return Dish.fromMap(query.docs.single.data());
      }

      dishes = await Future.wait<Dish>(
        categoriesId.map((category) => getOneDishFromCategory(category)),
      );
    } else {
      final query = await _firestore.collection('dishes').limit(5).get();
      dishes =
          query.docs.map<Dish>((dish) => Dish.fromMap(dish.data())).toList();
    }
    return dishes;
  }

  Future<List<Dish>> getDishesByCategory(
    String categoryId,
    int pageToken,
  ) async {
    List<Dish> dishes = [];
    final mainQuery = _firestore
        .collection('dishes')
        .where('categoryId', arrayContains: categoryId)
        .orderBy('addDate', descending: true);
    late Query<Map<String, dynamic>> query;
    if (pageToken == 0)
      query = mainQuery;
    else
      query = mainQuery.startAfter([pageToken]);
    final result = await query.limit(10).get(await internetValidation());
    dishes = result.docs.map<Dish>((dish) {
      return Dish.fromMap(dish.data());
    }).toList();
    return dishes;
  }

  Future<void> likeDish(String dishId) async {
    final userId = Get.context!.read<Auth>().wasfatUser?.uid;
    if (userId == null) return;
    final query = _firestore.collection('dishLikes').doc(dishId);
    await query.set(
      {
        'likes': FieldValue.arrayUnion([userId])
      },
      SetOptions(merge: true),
    );
  }

  Future<void> unlikeDish(String dishId) async {
    final userId = Get.context!.read<Auth>().wasfatUser?.uid;
    if (userId == null) return;
    final query = _firestore.collection('dishLikes').doc(dishId);
    await query.set(
      {
        'likes': FieldValue.arrayRemove([userId])
      },
      SetOptions(merge: true),
    );
  }

  Stream<List<String>> listenDishLikes(String dishId) async* {
    final query = _firestore.collection('dishLikes').doc(dishId).snapshots();
    final likes = query.map((event) =>
        List<String>.from(event.data()?['likes'] ?? const <String>[]));
    yield* likes;
  }

  Future<List<Dish>> searchDish(
    String query, {
    required List<String> categoriesId,
  }) async {
    final mainQuery = _firestore
        .collection('dishes')
        .orderBy('name')
        .startAt([query]).endAt([query + '\uf8ff']);

    late Query<Map<String, dynamic>> finalQuery;
    if (categoriesId.isEmpty)
      finalQuery = mainQuery;
    else
      finalQuery =
          mainQuery.where('categoryId', arrayContainsAny: categoriesId);
    final result = await finalQuery.get();
    print(result.docs);
    final dishes =
        result.docs.map<Dish>((dish) => Dish.fromMap(dish.data())).toList();
    return dishes;
  }
}
