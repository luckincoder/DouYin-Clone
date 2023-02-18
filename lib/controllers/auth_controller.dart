import 'dart:io';
import 'package:douyin_flutter/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:douyin_flutter/constants.dart';

class AuthController extends GetxController {
  //upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //registering the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //save user to auth and firebase firestore
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
            email: email,
            name: username,
            uid: userCredential.user!.uid,
            profilePhoto: downloadUrl);
      }
    } catch (e) {
      Get.snackbar(
        'Unable to Create Account',
        e.toString(),
      );
    }
  }
}
