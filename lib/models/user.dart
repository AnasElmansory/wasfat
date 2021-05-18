import 'dart:convert';

class WasfatUser {
  final String uid;
  final String displayName;
  final String? email;
  final String? photoURL;
  final String? phoneNumber;

  WasfatUser({
    required this.uid,
    required this.displayName,
    this.email,
    this.photoURL,
    this.phoneNumber,
  });

  WasfatUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    String? phoneNumber,
  }) {
    return WasfatUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
    };
  }

  factory WasfatUser.fromMap(Map<String, dynamic> map) {
    return WasfatUser(
      uid: map['uid'],
      displayName: map['displayName'],
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
    return 'WasfatUser(uid: $uid, displayName: $displayName, email: $email, photoURL: $photoURL, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WasfatUser &&
        other.uid == uid &&
        other.displayName == displayName &&
        other.email == email &&
        other.photoURL == photoURL &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        phoneNumber.hashCode;
  }
}
