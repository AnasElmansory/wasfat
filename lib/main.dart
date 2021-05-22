import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/providers/ad_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.initialize();
  init();
  runApp(const App());
  await AdmobProvider.showAppOpenAd();
}
