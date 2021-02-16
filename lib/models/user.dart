import 'dart:convert';

class WasfatUser {
  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String phoneNumber;

  WasfatUser({
    this.uid,
    this.name,
    this.email,
    this.photoURL,
    this.phoneNumber,
  });

  WasfatUser copyWith({
    String uid,
    String name,
    String email,
    String photoURL,
    String phoneNumber,
  }) {
    return WasfatUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
    };
  }

  factory WasfatUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WasfatUser(
      uid: map['uid'],
      name: map['displayName'],
      email: map['email'],
      photoURL: map['photoURL'],
      phoneNumber: map['phoneNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WasfatUser.fromJson(String source) =>
      WasfatUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WasfatUser(uid: $uid, name: $name, email: $email, photoURL: $photoURL, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WasfatUser &&
        o.uid == uid &&
        o.name == name &&
        o.email == email &&
        o.photoURL == photoURL &&
        o.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        phoneNumber.hashCode;
  }
}
