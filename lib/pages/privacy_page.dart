import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wasfat_akl/utils/constants.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        child: Html(
          data: privacy,
          onLinkTap: (url, _context, map, element) async {
            print(url);
            print(_context);
            print(map);
            print(element);
          },
        ),
      ),
    );
  }
}
