import 'dart:convert';

class Comment {
  final String id;
  final String dishId;
  final String ownerId;
  final String ownerName;
  final String? ownerPhotoURL;
  final String content;
  final DateTime commentDate;
  final int likes;
  final List<String> usersLikes;
  const Comment({
    required this.id,
    required this.dishId,
    required this.ownerId,
    required this.ownerName,
    required this.content,
    required this.commentDate,
    this.ownerPhotoURL,
    this.likes = 0,
    this.usersLikes = const <String>[],
  });

  Comment copyWith({
    String? id,
    String? dishId,
    String? ownerId,
    String? ownerName,
    String? ownerPhotoURL,
    String? content,
    DateTime? commentDate,
    int? likes,
    List<String>? usersLikes,
  }) {
    return Comment(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhotoURL: ownerPhotoURL ?? this.ownerPhotoURL,
      content: content ?? this.content,
      commentDate: commentDate ?? this.commentDate,
      likes: likes ?? this.likes,
      usersLikes: usersLikes ?? this.usersLikes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dishId': dishId,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhotoURL': ownerPhotoURL,
      'content': content,
      'commentDate': commentDate.millisecondsSinceEpoch,
      'likes': likes,
      'usersLikes': usersLikes,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      dishId: map['dishId'],
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      ownerPhotoURL: map['ownerPhotoURL'],
      content: map['content'],
      commentDate: DateTime.fromMillisecondsSinceEpoch(map['commentDate']),
      likes: map['likes'],
      usersLikes: List<String>.from(map['usersLikes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(id: $id, dishId: $dishId, ownerId: $ownerId, ownerName: $ownerName, ownerPhotoURL: $ownerPhotoURL, content: $content, commentDate: $commentDate, likes: $likes, usersLikes: $usersLikes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.dishId == dishId &&
        other.ownerId == ownerId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dishId.hashCode ^
        ownerId.hashCode ^
        ownerName.hashCode ^
        ownerPhotoURL.hashCode ^
        content.hashCode ^
        commentDate.hashCode ^
        likes.hashCode ^
        usersLikes.hashCode;
  }
}
