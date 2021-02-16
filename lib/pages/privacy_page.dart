import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wasfat_akl/helper/privacy_conditions.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(child: Html(data: privacy)),
    );
  }
}
