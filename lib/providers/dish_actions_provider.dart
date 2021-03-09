import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';

class DishProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final DataConnectionChecker _checker;

  DishProvider(this._firestore, this._checker);

  StreamSubscription _subscription;
  Dish _dish = Dish();
  Dish get dish => this._dish;
  set dish(Dish value) {
    this._dish = value;
    notifyListeners();
  }

  bool _isUpdatingLikes;
  bool get isUpdatingLikes => this._isUpdatingLikes;
  set isUpdatingLikes(bool value) => _isUpdatingLikes = value;

  int _rating = 5;
  int get rating => _rating;
  set rating(int value) {
    _rating = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void listenToDish(String dishId) => _subscription = _firestore
          .collection('dishes')
          .doc(dishId)
          .snapshots()
          .listen((snapshot) {
        dish = Dish.fromMap(snapshot.data());
        notifyListeners();
      });

  Future<void> onSendPressed(
    BuildContext context,
    String content,
    Auth auth,
  ) async {
    if (!auth.isLoggedIn)
      return await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );
    Comment _comment;
    if (content.isNotEmpty && content != null && content.length < 1500)
      _comment = Comment(
        id: Uuid().v1(),
        dishId: dish.id,
        ownerId: auth.userId,
        ownerName: auth.wasfatUser.name,
        ownerPhotoURL: auth.wasfatUser.photoURL,
        content: content,
        commentDate: DateTime.now(),
      );

    if (!await _checker.hasConnection)
      return await Fluttertoast.showToast(msg: 'تأكد من اتصالك بالانترنت');
    await rate(auth.userId);
    await comment(_comment);
  }

//? rating handling
  double getOneDishRating() {
    if (dish?.rating?.isEmpty ?? true) return 0.0;
    final result = (dish.rating.values == null || dish.rating.values.isEmpty)
        ? 0.0
        : dish.rating.values.reduce((a, b) => a + b) / dish.rating.length;

    return double.parse(result.toStringAsFixed(1));
  }

  Future<void> rate(String userId) async {
    final newRating = dish.rating..addAll({userId: rating});
    await _firestore
        .collection('dishes')
        .doc(dish.id)
        .update({'rating': newRating}).then(
            (_) async => await Fluttertoast.showToast(msg: 'تم ارسال تقييمك'));
  }

//!comments handling
  Future<void> comment(Comment comment) async => await _firestore
      .collection('comments')
      .doc(comment.id)
      .set(comment.toMap(), SetOptions(merge: true))
      .then((_) async => await Fluttertoast.showToast(msg: 'تم ارسال تعليقك'));

  Stream<List<Comment>> watchCommentByDish() async* {
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

  Stream<List<Comment>> watchFirstTwoComments(String dishId) async* {
    final query = _firestore
        .collection('comments')
        .where('dishId', isEqualTo: dishId)
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
    @required String userId,
    @required String commentId,
    @required String commentOwnerId,
  }) async {
    if (userId == commentOwnerId)
      await _firestore.collection('comments').doc(commentId).delete();
  }
  //* likes handling

  bool isLiked(String userId) => dish.usersLikes?.contains(userId) ?? false;

  Future<void> likeDish(
    String userId,
    Auth auth,
    BuildContext context,
  ) async {
    if (isUpdatingLikes) return;
    if (!auth.isLoggedIn)
      return await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignInPage()));

    if (!await _checker.hasConnection)
      return await Fluttertoast.showToast(msg: 'تأكد من اتصالك بالانترنت');

    if (isLiked(auth.userId)) return await unLikeDish(userId);
    isUpdatingLikes = true;
    await _firestore.collection('dishes').doc(dish.id).set({
      'usersLikes': FieldValue.arrayUnion([userId]),
      'likesCount': FieldValue.increment(1)
    }, SetOptions(merge: true)).then((_) => isUpdatingLikes = false);
  }

  Future<void> unLikeDish(String userId) async {
     isUpdatingLikes = true;
    await _firestore.collection('dishes').doc(dish.id).update({
      'usersLikes': FieldValue.arrayRemove([userId]),
      'likesCount': FieldValue.increment(-1)
    }).then((_) => isUpdatingLikes = false);
  }
}
