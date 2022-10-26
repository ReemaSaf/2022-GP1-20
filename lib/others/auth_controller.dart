import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/others/error_dialog.dart';
import 'package:sekkah_app/others/error_handelling.dart';
import 'package:sekkah_app/helpers/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.back();
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      // Get.snackbar("error", errorMessage.toString());
      showErrorDialog(errorMessage);
    }
  }

  Future<bool> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    try {
      UserCredential? credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (credentials.user != null) {
        UserModel user =
            UserModel(email: email, firstName: firstName, lastName: lastName);
        _firestore
            .collection('Passengers')
            .doc(credentials.user!.uid)
            .set(user.toMap());
      }
      Get.back();
      return true;
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      // Get.snackbar("error", errorMessage.toString());
      showErrorDialog(errorMessage);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Get.snackbar("Success", "Password link is sent."); // might delete it
      return true;
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      // Get.snackbar("error", errorMessage.toString());
      showErrorDialog(errorMessage);
      return false;
    }
  }

  Future<void> signUpAsGuest() async {
    try {
      await _auth.signInAnonymously(); // continue as guest
      UserModel user =
          UserModel(email: 'guest', firstName: "guest", lastName: 'guest');
      _firestore
          .collection('Passengers')
          .doc(_auth.currentUser!.uid)
          .set(user.toMap());
    } on Exception catch (err) {
      Get.snackbar("error", err.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on Exception catch (err) {
      Get.snackbar("error", err.toString());
    }
  }
}
