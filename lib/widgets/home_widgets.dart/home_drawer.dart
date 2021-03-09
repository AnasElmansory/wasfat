import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:wasfat_akl/helper/constants.dart';
import 'package:wasfat_akl/pages/favourite_dishlist_page.dart';
import 'package:wasfat_akl/pages/privacy_page.dart';
import 'package:wasfat_akl/pages/sign_in_page.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(auth.wasfatUser?.name ?? ''),
                    accountEmail: Text(auth.wasfatUser?.email ?? ''),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.teal[800],
                      backgroundImage: auth.wasfatUser?.photoURL != null
                          ? CachedNetworkImageProvider(
                              auth.wasfatUser.photoURL,
                            )
                          : null,
                      child: auth.wasfatUser?.photoURL == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 50,
                            )
                          : null,
                    ),
                    decoration:
                        const BoxDecoration(color: const Color(0xFFFF8F00)),
                  ),
                  if (!auth.isLoggedIn)
                    GFListTile(
                      title: const Text('تسجيل الدخول'),
                      avatar: const Icon(Icons.login, color: Colors.blue),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const SignInPage(),
                      )),
                    ),
                  GFListTile(
                    title: const Text('الاطباق المفضلة'),
                    avatar: const Icon(Icons.favorite, color: Colors.red),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const FavouriteListPage(),
                    )),
                  ),
                  GFListTile(
                    title: const Text("مشاركة التطبيق"),
                    avatar: const Icon(Icons.share, color: Colors.blue),
                    onTap: () async => await Share.share(appLink),
                  ),
                  GFListTile(
                    title: const Text('Privacy Policy'),
                    avatar: const Icon(
                      Icons.info_outline,
                      color: Colors.blueGrey,
                    ),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PrivacyPage())),
                  ),
                  if (auth.isLoggedIn)
                    GFListTile(
                      avatar: const Icon(Icons.power_settings_new),
                      title:
                          const Text('تسجيل خروج', textAlign: TextAlign.right),
                      onTap: () async =>
                          (auth.isLoggedIn) ? await auth.signOut() : null,
                    ),
                ],
              ),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text.rich(TextSpan(children: [
                    const TextSpan(text: 'By: OK2CODE Company'),
                    const TextSpan(text: '\n'),
                    TextSpan(
                        text:
                            'App version: ${snapshot.hasData ? snapshot.data.version : 'loading...'}'),
                    const TextSpan(text: '\n'),
                    const TextSpan(text: 'Mobile: (+20) 1025788855'),
                  ]))),
            ),
          ),
        ],
      ),
    );
  }
}
