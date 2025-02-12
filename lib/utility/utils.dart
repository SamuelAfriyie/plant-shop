import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shop/constant/const.dart';
import 'package:shop/models/plants.dart';
import 'package:shop/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static String generateRandomUserId() {
    final Random random = Random();
    const String characters =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    const int length = 10;
    String userId = '';

    for (int i = 0; i < length; i++) {
      final int randomIndex = random.nextInt(characters.length);
      userId += characters[randomIndex];
    }
    return userId;
  }

  static Future<bool> checkIfUserIdExists(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(userId)
              .get();

      return userDocument.exists;
    } catch (e) {
      return false;
    }
  }

  static Future<void> storeUserDataLocally(UserModel userModel) async {
    await localUser.setString('user_id', userModel.userId!);
    await localUser.setString('user_name', userModel.name!);
    await localUser.setBool('isAdmin', userModel.isAdmin!);
    await localUser.setString('bio', userModel.bio ?? '');
    await localUser.setString('profile_pic', userModel.profilePic ?? kP);
    await localUser.setStringList('plants', userModel.plantsId ?? <String>[]);
  }

  static Future<CroppedFile?> cropImage(String imagePath) async {
    CroppedFile? croppedFile;

    try {
      croppedFile = await ImageCropper.platform.cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        maxWidth: 800,
        cropStyle: CropStyle.circle,
        maxHeight: 800,
      );
    } catch (e) {
      e;
    }

    return croppedFile;
  }

  static Widget icon(String text, IconData icon, String description) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: 50,
          ),
          sh(5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          sh(5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> sendEmail(String username, PlantModel plant) async {
    final msg = _getEmailMessage(username, plant);
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'phaphalyagbaleti1@gmail.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': '#Order Info',
        'body': msg,
      }),
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      throw 'Could not launch email';
    }
  }

  static String _getEmailMessage(String senderUsername, PlantModel _) {
    return '''
      Hello,

      You have received a new order from $senderUsername:

      Pot: ${_.pot ?? ''}
      Title: ${_.title ?? ''}
      Price: ${_.price ?? ''}
      Height: ${_.height ?? ''}
      Plant ID: ${_.plantId ?? ''}
      Temperature: ${_.temperature ?? ''}
      Description: ${_.description ?? ''}
      
      Please process this order as soon as possible.

      Thank you.
    ''';
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
