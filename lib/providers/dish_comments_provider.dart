import 'dart:async';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_akl/firebase/comment_service.dart';
import 'package:wasfat_akl/models/comment.dart';
import 'package:wasfat_akl/models/user.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class DishCommentProvider extends ChangeNotifier {
  final CommentService _commentService;

  DishCommentProvider(this._commentService);

  StreamSubscription<List<Comment>>? _topTwoCommentSubscription;
  StreamSubscription<List<Comment>>? _commentsSubscription;

  List<Comment> _topTwoComments = [];
  List<Comment> get topTwoComments => this._topTwoComments;
  set topTwoComments(List<Comment> value) {
    this._topTwoComments = value;
    notifyListeners();
  }

  List<Comment> _comments = [];
  List<Comment> get comments => this._comments;
  set comments(List<Comment> value) {
    this._comments = value;
    notifyListeners();
  }

  int _rateValue = 5;
  int get getRateValue => this._rateValue;
  set setRateValue(int value) {
    this._rateValue = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _commentsSubscription?.cancel();
    _topTwoCommentSubscription?.cancel();
    super.dispose();
  }

  void initialRateValue(Map<String, int> rating) {
    final userId = Get.context!.read<Auth>().wasfatUser?.uid ?? '';
    if (rating.containsKey(userId)) _rateValue = rating[userId]!;
  }

  void listenToTopTwoComments(String dishId) async {
    await _topTwoCommentSubscription?.cancel();
    _topTwoCommentSubscription = null;
    _topTwoCommentSubscription = _commentService
        .listenToTopTwoComments(dishId)
        .listen((values) => topTwoComments = values);
  }

  void listenToDishComments(String dishId) async {
    await _commentsSubscription?.cancel();
    _commentsSubscription = null;
    _commentsSubscription = _commentService
        .listenToDishComments(dishId)
        .listen((events) => comments = events);
  }

  Future<void> onSendPressed(
    String content,
    String dishId,
    Map<String, int> rating,
  ) async {
    final auth = Get.context!.read<Auth>();
    if (!await auth.isLoggedIn()) return await navigateToSignPageUntil();
    Comment _comment;
    if (content.isEmpty && content.length > 1500) return;
    _comment = Comment(
      id: Uuid().v1(),
      dishId: dishId,
      ownerId: auth.wasfatUser!.uid,
      ownerName: auth.wasfatUser!.displayName,
      ownerPhotoURL: auth.wasfatUser!.photoURL,
      content: content,
      commentDate: DateTime.now(),
    );

    if (!await isConnected()) {
      await Fluttertoast.showToast(msg: 'تأكد من اتصالك بالانترنت');
      return;
    }
    await rate(dishId, rating);
    await comment(_comment);
  }

  Future<void> rate(String dishId, Map<String, int> rating) async {
    final userId = Get.context!.read<Auth>().wasfatUser!.uid;
    await _commentService.rate(userId, this._rateValue, dishId, rating);
  }

  Future<void> comment(Comment comment) async {
    await _commentService.comment(comment);
  }

  Future<void> deleteComment(String commentId) async {
    await _commentService.deleteComment(commentId);
  }

  Future<void> editComment(
    String content,
    Comment commentToEdit,
    WasfatUser user,
  ) async {
    final comment = commentToEdit.copyWith(
      ownerName: user.displayName,
      ownerPhotoURL: user.photoURL,
      content: content,
      commentDate: DateTime.now(),
    );
    await _commentService.comment(comment);
  }

  Future<void> likeComment(String commentId) async {
    final userId = Get.context!.read<Auth>().wasfatUser!.uid;
    await _commentService.likeComment(commentId, userId);
  }

  Future<void> unlikeComment(String commentId) async {
    final userId = Get.context!.read<Auth>().wasfatUser!.uid;
    await _commentService.unlikeComment(commentId, userId);
  }
}
