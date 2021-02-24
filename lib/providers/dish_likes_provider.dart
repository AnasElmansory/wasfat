import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DishLikesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  DishLikesProvider(this._firestore);
  List<String> dishLikes = <String>[];
  StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void listenDishLikes(String dishId) => _subscription = _firestore
      .collection('dishLikes')
      .doc(dishId)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists)
          return List<String>.from(snapshot.data()['likes']);
        else
          return const <String>[];
      })
      .asBroadcastStream()
      .listen((event) {
        dishLikes = event;
        notifyListeners();
      });

  Future<void> likeDish(String dishId, String userId) async {
    if (dishLikes.contains(userId)) return await unLikeDish(dishId, userId);

    await _firestore.collection('dishLikes').doc(dishId).set({
      'likes': FieldValue.arrayUnion([userId])
    }, SetOptions(merge: true));
  }

  Future<void> unLikeDish(String dishId, String userId) async =>
      await _firestore.collection('dishLikes').doc(dishId).update({
        'likes': FieldValue.arrayRemove([userId])
      });
}
