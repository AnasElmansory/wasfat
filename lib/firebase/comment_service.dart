import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wasfat_akl/models/comment.dart';

class CommentService {
  final FirebaseFirestore _firestore;

  const CommentService(this._firestore);

  //* listen to comments

  //* add comment
  //* edit comment
  //* delete comment
  //* like comment
  //* unlike comment
  //* add rate
  //* edit rate

  Future<void> rate(
    String userId,
    int rateValue,
    String dishId,
    Map<String, int> rating,
  ) async {
    final newRating = rating..addAll({userId: rateValue});
    await _firestore
        .collection('dishes')
        .doc(dishId)
        .update({'rating': newRating});
    await Fluttertoast.showToast(msg: 'تم ارسال تقييمك');
  }

//!comments handling
  Future<void> comment(Comment comment) async {
    await _firestore
        .collection('comments')
        .doc(comment.id)
        .set(comment.toMap(), SetOptions(merge: true));
    await Fluttertoast.showToast(msg: 'تم ارسال تعليقك');
  }

  Query<Map<String, dynamic>> commentQuery(String dishId) {
    return _firestore
        .collection('comments')
        .where('dishId', isEqualTo: dishId)
        .orderBy('commentDate', descending: true);
  }

  Stream<List<Comment>> listenToDishComments(String dishId) async* {
    yield* commentQuery(dishId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<Comment>((comment) => Comment.fromMap(comment.data()))
            .toList())
        .asBroadcastStream();
  }

  Stream<List<Comment>> listenToTopTwoComments(String dishId) async* {
    final query = commentQuery(dishId)
        .limit(2)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((comment) => Comment.fromMap(comment.data()))
            .toList())
        .asBroadcastStream();
    yield* query;
  }

  Future<void> likeComment(String commentId, String userId) async {
    await _firestore.collection('comments').doc(commentId).update({
      'likes': FieldValue.increment(1),
      'usersLikes': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> unlikeComment(String commentId, String userId) async {
    await _firestore.collection('comments').doc(commentId).update({
      'likes': FieldValue.increment(-1),
      'usersLikes': FieldValue.arrayRemove([userId])
    });
  }

  Future<void> deleteComment(String commentId) async {
    await _firestore.collection('comments').doc(commentId).delete();
  }
}
