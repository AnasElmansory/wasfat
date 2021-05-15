import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/utils/constants.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class TermsAndConditionPage extends StatelessWidget {
  const TermsAndConditionPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms And Conditions')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        child: const Text(
          'موافق',
          style: const TextStyle(color: Colors.white),
          textDirection: TextDirection.rtl,
        ),
        onPressed: () async {
          final result = await _acceptTermsAndConditions();
          if (result) await navigateToHomePage();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Html(data: conditions),
          ],
        ),
      ),
    );
  }
}

Future<bool> _acceptTermsAndConditions() async {
  final shared = await SharedPreferences.getInstance();
  final result = await shared.setBool('isFirstTime', true);
  return result;
}
