import 'dart:convert';

class Dish {
  final String id;
  final String name;
  final String? subtitle;
  final String dishDescription;
  final DateTime addDate;
  final Map<String, int> rating;
  final List<String> categoryId;
  final List<String>? dishImages;
  final String? dishVideo;

  const Dish({
    required this.id,
    required this.name,
    required this.rating,
    required this.addDate,
    required this.categoryId,
    required this.dishDescription,
    this.subtitle,
    this.dishVideo,
    this.dishImages,
  });

  Dish copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? dishDescription,
    DateTime? addDate,
    Map<String, int>? rating,
    List<String>? categoryId,
    List<String>? dishImages,
    String? dishVideo,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      dishDescription: dishDescription ?? this.dishDescription,
      addDate: addDate ?? this.addDate,
      rating: rating ?? this.rating,
      categoryId: categoryId ?? this.categoryId,
      dishImages: dishImages ?? this.dishImages,
      dishVideo: dishVideo ?? this.dishVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'dishDescription': dishDescription,
      'addDate': addDate.millisecondsSinceEpoch,
      'rating': rating,
      'categoryId': categoryId,
      'dishImages': dishImages,
      'dishVideo': dishVideo,
    };
  }

  factory Dish.fromMap(Map<String, dynamic> map) {
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
    return 'Dish(id: $id, name: $name, subtitle: $subtitle, dishDescription: $dishDescription, addDate: $addDate, rating: $rating, categoryId: $categoryId, dishImages: $dishImages, dishVideo: $dishVideo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dish && other.id == id;
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
