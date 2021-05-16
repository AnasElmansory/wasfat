import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
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
            final _canLaunch = await canLaunch(url ?? '');
            if (!_canLaunch) return;
            await launch(url!);
          },
        ),
      ),
    );
  }
}
