// ignore_for_file: non_constant_identifier_names, avoid_init_to_null, prefer_interpolation_to_compose_strings, avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Profile/widgets/show_loading_dialoges.dart';
import 'package:sekkah_app/others/error_dialog.dart';
import 'package:sekkah_app/others/error_handelling.dart';
import 'package:sekkah_app/helpers/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? LeftDuration = null;
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.back();
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      showErrorDialog(errorMessage);
    }
  }

  Future<bool> updateUserDetails({required UserModel userModel}) async {
    try {
      _firestore
          .collection('Passenger')
          .doc(_auth.currentUser!.uid)
          .set(userModel.toMap());

      Get.back();
      Get.snackbar(
          "Profile Updated", "Your Profile has been updated succesfully",
          backgroundColor: const Color(0xff50b2cc));
      return true;
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      showErrorDialog(errorMessage);
      return false;
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
      // Here, We are Encrypting the password so that nobody can see the password from Firebase console,
      //it takes the password as Text and user id as key to encrypt the password and the return us The encryrted Password which we use to send it to firebase
      var encryptedPassword =
          Encryptor.encrypt(_auth.currentUser!.uid, password);
      //Creating Model
      if (credentials.user != null) {
        UserModel user = UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: encryptedPassword,
        );
        //Sending UserModel To firebase
        _firestore
            .collection('Passenger')
            .doc(credentials.user!.uid)
            .set(user.toMap());
      }
      Get.back();
      return true;
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      showErrorDialog(errorMessage);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (err) {
      String errorMessage =
          ErrorHandelling.getMessageFromErrorCode(errorCode: err.code);
      showErrorDialog(errorMessage);
      return false;
    }
  }

  //Change Password Function , It takes New password and Old Password , This function is used in Change password Screen from Profile Section, please refer to that screen in order to understand how to use this function;
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      showLoadingDialog(
          message: "Processing..."); //Mainly Show prosseing dialog.
      final user =
          FirebaseAuth.instance.currentUser; //Getting firebase auth instance
      final cred = EmailAuthProvider.credential(
          //making credential ...
          email: user!.email!,
          password: currentPassword);
      await user.reauthenticateWithCredential(cred).then((value) async {
        //This is a function that reauthetciate and change password it take email and newpasssword as Credential to update/change the credentials
        await user.updatePassword(newPassword); //Here Updating new Password
        // When The password is change new password will also encrpted before updting it to firebase so that the securoty remains
        var encryptedPassword =
            Encryptor.encrypt(_auth.currentUser!.uid, newPassword);
        //Updating only passwordfeild in firebase with encrpted password
        await FirebaseFirestore.instance
            .collection('Passenger')
            .doc(user.uid)
            .update({'password': encryptedPassword});
      });
      //Clossing Dialog

      Get.back();
      hideLoadingDialog();
      //Profile updated- your profile has been updated successfully
      Get.snackbar(
          "Password Updated", "Your password has been updated successfully",
          backgroundColor: const Color(0xff50b2cc));
    } on Exception catch (e) {
      //Clossing Dialog
      hideLoadingDialog();
      showErrorDialog(e.toString());
    }
  }

  Future<void> signUpAsGuest() async {
    try {
      await _auth.signInAnonymously(); // continue as guest
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

  static Future<String?> checkIfUserHasPass() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser; //Getting firebase auth instance

      final db = FirebaseFirestore.instance;
      DocumentSnapshot userObj =
          await db.collection('Passenger').doc(user!.uid).get();

      final mUser = UserModel.fromMap(userObj.data() as Map<String, dynamic>);

      final currentDate = DateTime.now();
      final userDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(mUser.Pass_Expired_date));

      if (mUser.Pass_Expired_date == "0") {
        await db.collection('Passenger').doc(user!.uid).update(
          {
            'Pass_Expired_date': "0",
          },
        );
        LeftDuration = "Expired";
        return LeftDuration;
      } else if (currentDate.isBefore(userDate)) {
        var diff = userDate.difference(currentDate).inDays;
        if (diff == 0) {
          LeftDuration =
              userDate.difference(currentDate).inHours.toString() + " Hours";
        } else {
          if (diff == 1) {
            LeftDuration = diff.toString() + " Day";
          } else {
            LeftDuration = diff.toString() + " Days";
          }
        }
        return LeftDuration;
      } else if (currentDate.isAfter(userDate)) {
        await db.collection('Passenger').doc(user!.uid).update(
          {
            'Pass_Expired_date': "0",
          },
        );

        LeftDuration = "Expired";
        return LeftDuration;
      } else {
        await db.collection('Passenger').doc(user!.uid).update(
          {
            'Pass_Expired_date': "0",
          },
        );
        LeftDuration = "Expiring";
        return LeftDuration;
      }
    } on Exception catch (err) {
      Get.snackbar("error", err.toString());
    }
    return null;
  }

  static bool isAfterToday(int timestamp) {
    return DateTime.now().toUtc().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp,
            isUtc: false,
          ).toUtc(),
        );
  }

  static Future<void> savePass(
    int passTime,
    String passType,
    int price,
  ) async {
    try {
      showLoadingDialog(
          message: "Processing..."); //Mainly Show prosseing dialog.
      final user =
          FirebaseAuth.instance.currentUser; //Getting firebase auth instance

      final db = FirebaseFirestore.instance;

      DocumentSnapshot userObj =
          await db.collection('Passenger').doc(user!.uid).get();

      final mUser = UserModel.fromMap(userObj.data() as Map<String, dynamic>);
      print(mUser.email.toString());

      var expiredDate;

      if (mUser.Pass_Expired_date != "0") {
        var alreadyTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(mUser.Pass_Expired_date));

        expiredDate =
            alreadyTime.add(Duration(days: passTime)).millisecondsSinceEpoch;
      } else {
        expiredDate =
            DateTime.now().add(Duration(days: passTime)).millisecondsSinceEpoch;
      }

      print(expiredDate);

      await db.collection('Passenger').doc(user!.uid).update(
        {
          'Pass_Expired_date': expiredDate.toString(),
          'passType': passType,
          'price': price,
        },
      );

      //Clossing Dialog

      Get.back();
      hideLoadingDialog();
      //Profile updated- your profile has been updated successfully

    } on Exception catch (e) {
      //Clossing Dialog
      hideLoadingDialog();
      showErrorDialog(e.toString());
    }
  }
}
