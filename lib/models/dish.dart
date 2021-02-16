import 'dart:convert';

import 'package:flutter/foundation.dart';

class Dish {
  final String id;
  final String name;
  final String subtitle;
  final String dishDescription;
  final DateTime addDate;
  final Map<String, int> rating;
  final List<String> categoryId;
  final List<String> dishImages;
  final String dishVideo;

  Dish({
    this.id,
    this.name,
    this.subtitle,
    this.categoryId,
    this.dishDescription,
    this.addDate,
    this.rating,
    this.dishImages,
    this.dishVideo,
  });

  Dish copyWith({
    String id,
    String name,
    String subtitle,
    String dishDescription,
    DateTime addDate,
    Map<String, int> rating,
    List<String> categoryId,
    List<String> dishImages,
    String dishVideo,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      categoryId: categoryId ?? this.categoryId,
      dishDescription: dishDescription ?? this.dishDescription,
      addDate: addDate ?? this.addDate,
      rating: rating ?? this.rating,
      dishImages: dishImages ?? this.dishImages,
      dishVideo: dishVideo ?? this.dishVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'categoryId': categoryId,
      'dishDescription': dishDescription,
      'addDate': addDate?.millisecondsSinceEpoch,
      'rating': rating,
      'dishImages': dishImages,
      'dishVideo': dishVideo,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Dish(
      id: map['id'],
      name: map['name'],
      subtitle: map['subtitle'],
      dishDescription: map['dishDescription'],
      addDate: DateTime.fromMillisecondsSinceEpoch(map['addDate']),
      rating: Map<String, int>.from(map['rating']),
      categoryId: List<String>.from(map['categoryId']),
      dishImages: List<String>.from(map['dishImages']),
      dishVideo: map['dishVideo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Dish.fromJson(String source) => Dish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Dish(id: $id, name: $name, categoryId: $categoryId, subtitle: $subtitle,dishDescription: $dishDescription, addDate: $addDate, rating: $rating, dishImages: $dishImages, dishVideo: $dishVideo)';
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
        mapEquals(o.rating, rating) &&
        listEquals(o.categoryId, categoryId) &&
        listEquals(o.dishImages, dishImages) &&
        o.dishVideo == dishVideo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        subtitle.hashCode ^
        categoryId.hashCode ^
        dishDescription.hashCode ^
        addDate.hashCode ^
        rating.hashCode ^
        dishImages.hashCode ^
        dishVideo.hashCode;
  }
}
