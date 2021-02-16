import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'dish.dart';

class FoodCategory {
  final String id;
  final String name;
  final String imageUrl;
  final String banner;
  final List<Dish> dishes;

  FoodCategory({
    this.id,
    this.name,
    this.imageUrl,
    this.banner,
    this.dishes,
  });

  FoodCategory copyWith({
    String id,
    String name,
    String imageUrl,
    String banner,
    List<Dish> dishes,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      banner: banner ?? this.banner,
      dishes: dishes ?? this.dishes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'banner': banner,
      'dishes': dishes?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory FoodCategory.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FoodCategory(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      banner: map['banner'],
      dishes: map['dishes'] as List<Dish> ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodCategory.fromJson(String source) =>
      FoodCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodCategory(id: $id, name: $name, imageUrl: $imageUrl, banner: $banner, dishes: $dishes)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FoodCategory &&
        o.id == id &&
        o.name == name &&
        o.imageUrl == imageUrl &&
        o.banner == banner &&
        listEquals(o.dishes, dishes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        banner.hashCode ^
        dishes.hashCode;
  }
}
