import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_akl/utils/internet_helper.dart';

typedef Sign = Future<void> Function();

class SignInPage extends StatelessWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final auth = context.watch<Auth>();

    Future<void> signWithGoogle() async {
      await auth.signInWithGoogle();
      if (await auth.isLoggedIn()) Get.back();
    }

    Future<void> signWithFacebook() async {
      await auth.signInWithFacebook();
      if (await auth.isLoggedIn()) Get.back();
    }

    return Scaffold(
      appBar: AppBar(elevation: 0),
      backgroundColor: Colors.amber[700],
      body: Container(
        height: size.height * 0.8,
        width: size.width,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 50),
              Expanded(
                flex: 2,
                child: const Text(
                  '! مرحبا',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    'قم بتسجيل الدخول لتتمكن من اضافه تعليق',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  if (!await isConnected())
                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(
                          label: 'حاول مره أخرى',
                          onPressed: () async => await signWithGoogle()),
                      content: const Text('تأكد من اتصالك باللانترنت'),
                    ));
                  else
                    await signWithGoogle();
                },
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Or', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              SignInButton(
                Buttons.Facebook,
                onPressed: () async {
                  if (!await isConnected())
                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(
                          label: 'حاول مره أخرى',
                          onPressed: () async => await signWithFacebook()),
                      content: const Text('تأكد من اتصالك باللانترنت'),
                    ));
                  else
                    await signWithFacebook();
                },
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
