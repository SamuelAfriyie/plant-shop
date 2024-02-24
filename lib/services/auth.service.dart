// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop/constant/const.dart';
import 'package:shop/repositorys/auth.repository.dart';

class AuthService {
  void googleSign(BuildContext context) async {
    AuthRepository state = Provider.of<AuthRepository>(context, listen: false);

    HapticFeedback.heavyImpact();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await kAuth.signInWithCredential(credential);
    User user = userCredential.user!;
    kAnalytics.logSignUp(signUpMethod: 'Google Register');
    await state.signupProcess(context, user);
  }

  Future<bool> checkStatus(BuildContext context) async {
    try {
      final uid = localUser.getString('user_id') ?? '';
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await kFirestore.collection('profiles').doc(uid).get();
      Map<String, dynamic> map = userDocument.data()!;
      // await localUser.setBool("isAdmin", map["isAdmin"]);
      return map['isAdmin'] as bool;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
