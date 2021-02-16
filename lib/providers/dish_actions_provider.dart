import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/dish.dart';

class DishProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  DishProvider(this._firestore);

  var usersRating = Map<String, int>();

  double _dishRating = 0.0;
  double get dishRating => _dishRating;
  set dishRating(double value) {
    _dishRating = value;
    notifyListeners();
  }

  int _rating = 5;
  int get rating => _rating;
  set rating(int value) {
    _rating = value;
    notifyListeners();
  }

  Future<void> getOneDishRating(String dishId, {String userId}) async {
    final query = await _firestore.collection('dishes').doc(dishId).get();
    final ratingQuery = Map<String, int>.from(query.data()['rating']);
    if (userId != null) rating = ratingQuery[userId];
    usersRating = ratingQuery;
    notifyListeners();
    final result = (ratingQuery.values == null || ratingQuery.values.isEmpty)
        ? 0.0
        : ratingQuery.values.reduce((a, b) => a + b) / ratingQuery.length;

    dishRating = double.parse(result.toStringAsFixed(1));
  }

  Future<void> rate(String dishId, String userId) async {
    final query = await _firestore.collection('dishes').doc(dishId).get();
    final newRating = Map<String, int>.from(query.data()['rating'])
      ..addAll({userId: rating ?? 5});

    await _firestore
        .collection('dishes')
        .doc(dishId)
        .update({'rating': newRating}).then(
            (_) async => await Fluttertoast.showToast(msg: 'تم ارسال تقييمك'));
  }

  Future<void> comment(Comment comment) async => await _firestore
      .collection('comments')
      .doc(comment.id)
      .set(comment.toMap(), SetOptions(merge: true))
      .then((_) async => await Fluttertoast.showToast(msg: 'تم ارسال تعليقك'));

  Stream<List<Comment>> watchCommentByDish(Dish dish) async* {
    yield* _firestore
        .collection('comments')
        .where('dishId', isEqualTo: dish.id)
        .orderBy('commentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<Comment>((comment) => Comment.fromMap(comment.data()))
            .toList())
        .asBroadcastStream();
  }

  Stream<List<Comment>> watchFirstTwoComments(Dish dish) async* {
    final query = _firestore
        .collection('comments')
        .where('dishId', isEqualTo: dish.id)
        .orderBy('commentDate', descending: true)
        .limit(2)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((comment) => Comment.fromMap(comment.data()))
            .toList())
        .asBroadcastStream();
    yield* query;
  }

  Future<void> likeAComment(Comment comment, String userId) async {
    if (comment.usersLikes.contains(userId)) return;
    await _firestore.collection('comments').doc(comment.id).update({
      'likes': FieldValue.increment(1),
      'usersLikes': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> dislikeAComment(Comment comment, String userId) async {
    if (!comment.usersLikes.contains(userId)) return;
    await _firestore.collection('comments').doc(comment.id).update({
      'likes': FieldValue.increment(-1),
      'usersLikes': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> deleteComment({
    @required String commentId,
    @required String userId,
    @required String commentOwnerId,
  }) async {
    if (userId == commentOwnerId)
      await _firestore.collection('comments').doc(commentId).delete();
  }
}
