import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:wasfat_akl/utils/constants.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/utils/navigation.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final size = context.mediaQuerySize;
    return Container(
      height: size.height,
      child: Drawer(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(auth.wasfatUser?.displayName ?? ''),
                      accountEmail: Text(auth.wasfatUser?.email ?? ''),
                      currentAccountPicture: CircularProfileAvatar(
                        auth.wasfatUser?.photoURL ?? '',
                        errorWidget: (_, __, ___) {
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                          );
                        },
                        initialsText: const Text(
                          'Guest',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        borderColor: Colors.amber[700]!,
                        backgroundColor: Colors.teal[700]!,
                        borderWidth: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: const Color(0xFFFF8F00),
                      ),
                    ),
                    if (!auth.isSignedIn)
                      GFListTile(
                        title: const Text('تسجيل الدخول'),
                        avatar: const Icon(Icons.login, color: Colors.blue),
                        onTap: () async => await navigateToSignPageUntil(),
                      ),
                    GFListTile(
                        title: const Text('الاطباق المفضلة'),
                        avatar: const Icon(Icons.favorite, color: Colors.red),
                        onTap: () async => await navigateToFavouriteListPage()),
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
                      onTap: () async => navigateToPrivacyPage(),
                    ),
                    if (auth.isSignedIn)
                      GFListTile(
                        avatar: const Icon(Icons.power_settings_new),
                        title: const Text(
                          'تسجيل خروج',
                          textAlign: TextAlign.right,
                        ),
                        onTap: () async {
                          if (await auth.isLoggedIn())
                            return await auth.signOut();
                        },
                      ),
                  ],
                ),
                Container(
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final result = snapshot.hasData
                          ? snapshot.data?.version
                          : 'loading...';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(text: 'By: OK2CODE Company'),
                              const TextSpan(text: '\n'),
                              TextSpan(text: 'App version: $result'),
                              const TextSpan(text: '\n'),
                              const TextSpan(text: 'Mobile: (+20) 1025788855'),
                            ]))),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
