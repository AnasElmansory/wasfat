import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wasfat_akl/helper/constants.dart';
import 'package:wasfat_akl/models/dish.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';

class Messaging {
  final Auth _auth;
  final dio = Dio();
  Messaging(this._auth);

  Future<void> sendToCategory(Dish dish) async {
    final token = await _auth.getAccessToken();
    final headers = <String, String>{
      'Authorization': 'Bearer ' + token,
      'Content-Type': 'application/json',
    };

    final data = {
      "message": {
        "topic": "${dish.name}",
        "notification": {
          "title": "${dish.name}",
          "body": "blabla",
        }
      }
    };
    await dio.post(baseUrl,
        options: Options(headers: headers), data: json.encode(data));
  }
}
