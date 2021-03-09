import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:wasfat_akl/get_it.dart';
import 'package:wasfat_akl/providers/auth_provider.dart';
import 'package:provider/provider.dart';

typedef Sign = Future<void> Function();

class SignInPage extends StatelessWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context) {
    final checker = getIt<DataConnectionChecker>();
    final size = MediaQuery.of(context).size;
    final auth = context.watch<Auth>();
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
                  final Sign signMethod =
                      () async => await auth.signInWithGoogle().then((_) async {
                            if (context.read<Auth>().isLoggedIn)
                              Navigator.of(context).pop();
                          });
                  if (!await checker.hasConnection)
                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(
                          label: 'حاول مره أخرى',
                          onPressed: () async => await signMethod()),
                      content: const Text('تأكد من اتصالك باللانترنت'),
                    ));
                  else
                    await signMethod();
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
                  final Sign signMethod = () async {
                    await auth.signInWithFacebook().then((_) async {
                      if (context.read<Auth>().isLoggedIn)
                        Navigator.of(context).pop();
                    });
                  };
                  if (!await checker.hasConnection)
                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      action: SnackBarAction(
                          label: 'حاول مره أخرى',
                          onPressed: () async => await signMethod()),
                      content: const Text('تأكد من اتصالك باللانترنت'),
                    ));
                  else
                    await signMethod();
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
