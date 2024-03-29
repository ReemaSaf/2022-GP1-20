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
     
      // Here, We are encrypting the password so that nobody can see the password from the Firebase console,

      var encryptedPassword =
          Encryptor.encrypt(_auth.currentUser!.uid, password);
      //it takes the password as Text and the user id as key to encrypt the password and then it will return the encryrted Password which we will use to send it to firebase


      //Creating the UserModel
      if (credentials.user != null) {
        UserModel user = UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: encryptedPassword,
        );

        //Sending the UserModel To firebase
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

  //the Change Password Function takes both the New password and the Old Password (this function is used in the Change password Screen located in the Profile Section).
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      showLoadingDialog(
          message: "Processing..."); //Mainly Show the processing dialog.
      final user =
          FirebaseAuth.instance.currentUser; //Getting firebase auth instance
      final cred = EmailAuthProvider.credential(
          //making credential ...
          email: user!.email!,
          password: currentPassword);
      await user.reauthenticateWithCredential(cred).then((value) async {
        //This is a function that reauthentciates the user and then changes the password if successfully validated,  it takes the email and OldPasssword as Credential to update/change the user's password.
        await user.updatePassword(newPassword); //Here Updating into the new Password
        // When The password is changed, new password will be encrpted as well before updating it to firebase so that the security remains.
        var encryptedPassword =
            Encryptor.encrypt(_auth.currentUser!.uid, newPassword);
        //Updating only the password field in firebase with the new encrpted password
        await FirebaseFirestore.instance
            .collection('Passenger')
            .doc(user.uid)
            .update({'password': encryptedPassword});
      });
      //Closing Dialog

      Get.back();
      hideLoadingDialog();
      Get.snackbar(
          "Password Updated", "Your password has been updated successfully",
          backgroundColor: const Color(0xff50b2cc));
    } on Exception catch (e) {
      //Closing Dialog
      hideLoadingDialog();
      showErrorDialog(e.toString());
    }
  }

  Future<void> signUpAsGuest() async {
    try {
      await _auth.signInAnonymously(); // Continue as guest
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
          
        },
      );

      //Closing Dialog

      Get.back();
      hideLoadingDialog();

    } on Exception catch (e) {
      //Closing Dialog
      hideLoadingDialog();
      showErrorDialog(e.toString());
    }
  }
}
