import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wasfat_akl/models/user.dart';

class Auth extends ChangeNotifier {
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final DataConnectionChecker _checker;

  Auth(
    this._googleSignIn,
    this._facebookAuth,
    this._firebaseAuth,
    this._firestore,
    this._checker,
  );

  WasfatUser wasfatUser;

  bool get isLoggedIn => (_firebaseAuth.currentUser == null) ? false : true;
  String get userId => _firebaseAuth.currentUser?.uid;

  Future<void> signOut() async {
    await _facebookAuth.logOut();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    wasfatUser = null;
    notifyListeners();
  }

  Future<void> getUserData() async {
    if (isLoggedIn) {
      final userSnapshot = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser.uid)
          .get();
      wasfatUser = WasfatUser.fromMap(userSnapshot.data());
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
      email: user.email,
      name: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null)
      return await Fluttertoast.showToast(msg: 'sign in failed');
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken, accessToken: auth.accessToken);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await saveUserData(userCredential.user);
    notifyListeners();
  }

  Future<void> signInWithFacebook() async {
    final accessToken = await _facebookAuth.login();
    if (accessToken == null)
      return await Fluttertoast.showToast(msg: 'sign in failed');
    final credential = FacebookAuthProvider.credential(accessToken.token);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await saveUserData(userCredential.user);
    notifyListeners();
  }
}
