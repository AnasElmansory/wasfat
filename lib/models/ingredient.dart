import 'dart:convert';

class Ingredients {
  final String id;
  final String ingredientName;
  final String ingredientAmount;
  Ingredients({
    this.id,
    this.ingredientName,
    this.ingredientAmount,
  });

  Ingredients copyWith({
    String id,
    String ingredientName,
    String ingredientAmount,
  }) {
    return Ingredients(
      id: id ?? this.id,
      ingredientName: ingredientName ?? this.ingredientName,
      ingredientAmount: ingredientAmount ?? this.ingredientAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredientName': ingredientName,
      'ingredientAmount': ingredientAmount,
    };
  }

  factory Ingredients.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Ingredients(
      id: map['id'],
      ingredientName: map['ingredientName'],
      ingredientAmount: map['ingredientAmount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Ingredients.fromJson(String source) =>
      Ingredients.fromMap(json.decode(source));

  @override
  String toString() =>
      'Ingredients(id: $id, ingredientName: $ingredientName, ingredientAmount: $ingredientAmount)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Ingredients &&
        o.id == id &&
        o.ingredientName == ingredientName &&
        o.ingredientAmount == ingredientAmount;
  }

  @override
  int get hashCode =>
      id.hashCode ^ ingredientName.hashCode ^ ingredientAmount.hashCode;
}
