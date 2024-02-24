import 'package:shop/constant/const.dart';
import 'package:shop/models/user.dart';

class ProfileService {
  Future<void> updateProfile(UserModel model) async {
    await kFirestore
        .collection('profiles')
        .doc(model.userId)
        .update(model.toJson());
  }

  Future<void> deleteProfile(String userId) async {
    await kFirestore.collection('profiles').doc(userId).delete();
  }
}
