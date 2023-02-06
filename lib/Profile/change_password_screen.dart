// ignore_for_file: must_be_immutable

import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Profile/widgets/custom_appbar.dart';
import 'package:sekkah_app/Profile/widgets/custom_elevated_button.dart';
import 'package:sekkah_app/Profile/widgets/custom_wrap.dart';
import 'package:sekkah_app/data/assets.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';
import 'package:sekkah_app/helpers/user_model.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import 'package:sekkah_app/others/error_dialog.dart';

import 'profile_textfeil.dart';
import '../constants/app_colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  final UserModel user;
  ChangePasswordScreen({Key? key, required this.user}) : super(key: key);

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blueDarkColor,
        appBar: const CustomAppBar(
          title: 'Change Password',
          showBack: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30.h,
                    ),
                    WrapContainer(
                      child: Stack(
                        children: [
                          Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                                    margin: EdgeInsets.only(top: 500.h),
                            height: 220.h,
                            width: Get.width,
                            decoration: const  BoxDecoration(
                              
                                image:  DecorationImage(
                                   fit: BoxFit.fitWidth,
                                    image: AssetImage(CustomAssets.crossrailtracks),
                                   )),),
                    ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.w),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  
                                  SizedBox(
                                    height: 58.h,
                                  ),
                                  Text('Old Password',
                                      style: CustomTextStyle.klarge.copyWith(
                                          color: CustomColor.kblack,
                                          fontWeight:
                                              CustomFontWeight.kMediumFontWeight)),
                                  SizedBox(
                                    child: ProfileTextFeild(
                                      controller: oldPassword,
                                      showHideIcon: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Enter Old Password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28.h,
                                  ),
                                  Text("New Password",
                                      style: CustomTextStyle.klarge.copyWith(
                                          color: CustomColor.kblack,
                                          fontWeight:
                                              CustomFontWeight.kMediumFontWeight)),
                                  SizedBox(
                                    child: ProfileTextFeild(
                                      controller: newPassword,
                                      showHideIcon: true,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please Enter your Password.';
                                        }
                                        if (newPassword.text.length < 8) {
                                          return 'Password must be at least 8 characters.';
                                        }
                                        if (newPassword.text
                                                    .contains(RegExp(r'[0-9]')) ==
                                                false ||
                                            newPassword.text
                                                    .contains(RegExp(r'[A-Z]')) ==
                                                false ||
                                            newPassword.text
                                                    .contains(RegExp(r'[a-z]')) ==
                                                false) {
                                          return 'Password must contain at least one upperrcase letter , lowercase letter and a number.';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 66.h,
                                  ),
                                  Center(
                                      child: CustomElevatedButton(
                                    iconUrl: CustomAssets.updateicon,
                                    title: 'Update',
                                    onPressed: () async {
                                      // Decryption Password ..
                                      var decryptedPassword = Encryptor.decrypt(
                                          _auth.currentUser!.uid,
                                          user.password!); //This function is used to decrypt password and takes key and text. Here I provide key as users id and text as Password.After decryption it will compare .
                                      if (_formKey.currentState!.validate()) {
                                        if (decryptedPassword == oldPassword.text) {
                                          //checking the given Password is same as oldPassword if its Same then it proceeds to Update the password
                                          await AuthController().changePassword(
                                              //Function which take old and newpassword to Update it. This function is created in AuthController class.
                                              oldPassword.text,
                                              newPassword.text);
                                        } else {
                                          showErrorDialog(
                                              'Old Password is Incorrect');
                                        }
                                      }
                                    },
                                  )),
                                  SizedBox(
                                    height: 355.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
