import 'dart:convert';

import 'package:flutter/foundation.dart';

class Dish {
  final String id;
  final String name;
  final String subtitle;
  final String dishDescription;
  final int likesCount;
  final DateTime addDate;
  final Map<String, int> rating;
  final List<String> categoryId;
  final List<String> dishImages;
  final List<String> usersLikes;
  final String dishVideo;

  Dish({
    this.id,
    this.name,
    this.subtitle,
    this.dishDescription,
    this.addDate,
    this.likesCount = 0,
    this.rating,
    this.categoryId,
    this.dishImages,
    this.usersLikes,
    this.dishVideo,
  });

  Dish copyWith({
    String id,
    String name,
    String subtitle,
    String dishDescription,
    DateTime addDate,
    int likesCount,
    Map<String, int> rating,
    List<String> categoryId,
    List<String> dishImages,
    List<String> usersLikes,
    String dishVideo,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      dishDescription: dishDescription ?? this.dishDescription,
      addDate: addDate ?? this.addDate,
      likesCount: likesCount ?? this.likesCount,
      rating: rating ?? this.rating,
      categoryId: categoryId ?? this.categoryId,
      dishImages: dishImages ?? this.dishImages,
      usersLikes: usersLikes ?? this.usersLikes,
      dishVideo: dishVideo ?? this.dishVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'dishDescription': dishDescription,
      'addDate': addDate?.millisecondsSinceEpoch,
      'likesCount': likesCount,
      'rating': rating,
      'categoryId': categoryId,
      'dishImages': dishImages,
      'usersLikes': usersLikes,
      'dishVideo': dishVideo,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Dish(
      id: map['id'] as String,
      name: map['name'] as String,
      subtitle: map['subtitle'] as String,
      dishDescription: map['dishDescription'] as String,
      likesCount: map['likesCount'] as int,
      addDate: DateTime.fromMillisecondsSinceEpoch(map['addDate']),
      rating: Map<String, int>.from(map['rating'] ?? {}),
      categoryId: List<String>.from(map['categoryId'] ?? []),
      dishImages: List<String>.from(map['dishImages'] ?? []),
      usersLikes: List<String>.from(map['usersLikes'] ?? []),
      dishVideo: map['dishVideo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Dish.fromJson(String source) => Dish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Dish(id: $id, name: $name, subtitle: $subtitle, dishDescription: $dishDescription, addDate: $addDate, rating: $rating, categoryId: $categoryId, dishImages: $dishImages, dishVideo: $dishVideo)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Dish &&
        o.id == id &&
        o.name == name &&
        o.subtitle == subtitle &&
        o.dishDescription == dishDescription &&
        o.addDate == addDate &&
        listEquals(o.categoryId, categoryId) &&
        // listEquals(o.dishImages, dishImages) &&
        o.dishVideo == dishVideo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        subtitle.hashCode ^
        dishDescription.hashCode ^
        addDate.hashCode ^
        rating.hashCode ^
        categoryId.hashCode ^
        dishImages.hashCode ^
        dishVideo.hashCode;
  }
}
