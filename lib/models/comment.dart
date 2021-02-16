import 'dart:convert';

import 'package:flutter/foundation.dart';

class Comment {
  final String id;
  final String dishId;
  final String ownerId;
  final String ownerName;
  final String ownerPhotoURL;
  final String content;
  final DateTime commentDate;
  final int likes;
  final List<String> usersLikes;
  Comment({
    this.id,
    this.dishId,
    this.ownerId,
    this.ownerName,
    this.ownerPhotoURL,
    this.content,
    this.commentDate,
    this.likes = 0,
    this.usersLikes = const <String>[],
  });

  Comment copyWith({
    String id,
    String dishId,
    String ownerId,
    String ownerName,
    String ownerPhotoURL,
    String content,
    DateTime commentDate,
    int likes,
    List<String> usersLikes,
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
      'commentDate': commentDate?.millisecondsSinceEpoch,
      'likes': likes,
      'usersLikes': usersLikes,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

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
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Comment &&
        o.id == id &&
        o.dishId == dishId &&
        o.ownerId == ownerId &&
        o.ownerName == ownerName &&
        o.ownerPhotoURL == ownerPhotoURL &&
        o.content == content &&
        o.commentDate == commentDate &&
        o.likes == likes &&
        listEquals(o.usersLikes, usersLikes);
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
