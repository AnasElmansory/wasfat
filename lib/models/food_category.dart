import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'dish.dart';

class FoodCategory {
  final String id;
  final String name;
  final String imageUrl;
  final List<Dish>? dishes;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.dishes,
  });

  FoodCategory copyWith({
    String? id,
    String? name,
    String? imageUrl,
    List<Dish>? dishes,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      dishes: dishes ?? this.dishes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'dishes': dishes?.map((x) => x.toMap()).toList(),
    };
  }

  factory FoodCategory.fromMap(Map<String, dynamic> map) {
    final dishes = map['dishes'] != null
        ? List<Dish>.from(map['dishes'].map((x) => Dish.fromMap(x)))
        : null;
    return FoodCategory(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      dishes: dishes,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodCategory.fromJson(String source) =>
      FoodCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodCategory(id: $id, name: $name, imageUrl: $imageUrl,  dishes: $dishes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodCategory &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        listEquals(other.dishes, dishes);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode ^ dishes.hashCode;
  }
}
