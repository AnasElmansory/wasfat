import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_akl/get_it.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  init();
  runApp(App());
}
