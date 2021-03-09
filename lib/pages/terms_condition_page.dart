import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wasfat_akl/helper/constants.dart';
import 'package:wasfat_akl/pages/home_page.dart';
import 'package:wasfat_akl/providers/shared_preferences_provider.dart';
import 'package:provider/provider.dart';

class TermsAndConditionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shared = context.watch<SharedPreferencesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms And Conditions'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        child: const Text(
          'موافق',
          style: const TextStyle(
            color: Colors.white,
          ),
          textDirection: TextDirection.rtl,
        ),
        onPressed: () async {
          final result = await shared.acceptedTermsAndConditions();
          if (result)
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomePage()));
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
