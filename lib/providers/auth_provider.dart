import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_akl/models/user.dart';

class Auth extends ChangeNotifier {
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Auth(
    this._googleSignIn,
    this._facebookAuth,
    this._firebaseAuth,
    this._firestore,
  );

  WasfatUser? wasfatUser;

  bool _isSignedIn = false;
  bool get isSignedIn => this._isSignedIn;

  Future<bool> isLoggedIn() async {
    final shared = await SharedPreferences.getInstance();
    final _isLoggedIn = shared.getBool('isLoggedIn') ?? false;
    final isUser = _firebaseAuth.currentUser != null;
    return _isLoggedIn && isUser ? true : false;
  }

  Future<void> signOut() async {
    await _facebookAuth.logOut();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    wasfatUser = null;
    notifyListeners();
  }

  Future<void> getUserData() async {
    if (await isLoggedIn()) {
      final userData = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      if (userData.data() == null) return;
      wasfatUser = WasfatUser.fromMap(userData.data()!);
      this._isSignedIn = true;
      notifyListeners();
    }
  }

  Future<void> saveUserData(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'phoneNumber': user.phoneNumber
    });
    wasfatUser = WasfatUser(
      uid: user.uid,
      displayName: user.displayName ?? 'User',
      email: user.email ?? 'User@email.com',
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      await Fluttertoast.showToast(msg: GoogleSignIn.kSignInCanceledError);
      return;
    }
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.user == null) {
      await Fluttertoast.showToast(msg: GoogleSignIn.kSignInFailedError);
      return;
    }
    await saveUserData(userCredential.user!);
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('isLoggedIn', true);
    this._isSignedIn = true;
    notifyListeners();
  }

  Future<void> signInWithFacebook() async {
    final loginResult = await _facebookAuth.login();

    Future<void> _loginFailed() async {
      await Fluttertoast.showToast(msg: FacebookAuthErrorCode.FAILED);
      return;
    }

    if (loginResult.status == LoginStatus.cancelled) {
      await Fluttertoast.showToast(msg: FacebookAuthErrorCode.CANCELLED);
      return;
    } else if (loginResult.status == LoginStatus.failed)
      return await _loginFailed();

    final accessToken = loginResult.accessToken;
    if (accessToken == null) return await _loginFailed();
    final credential = FacebookAuthProvider.credential(accessToken.token);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.user == null) return await _loginFailed();
    await saveUserData(userCredential.user!);
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('isLoggedIn', true);
    this._isSignedIn = true;
    notifyListeners();
  }
}
