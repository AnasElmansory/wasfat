import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasfat_akl/models/food_category.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';

class CategoriesService {
  final FirebaseFirestore _firestore;

  const CategoriesService(this._firestore);
  Future<List<FoodCategory>> getCategories() async {
    final query = await _firestore
        .collection('food_category')
        .orderBy('priority')
        .get(await internetValidation());
    final categories = query.docs.map<FoodCategory>((category) {
      return FoodCategory.fromMap(category.data());
    }).toList();
    return categories;
  }
}
