// ignore_for_file: unused_local_variable

import 'dart:io';

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

import 'profile_textfeil.dart';
import '../constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstName = TextEditingController();

  final TextEditingController lastName = TextEditingController();

  final TextEditingController email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String imageUrl = '';
  File? image;

  @override
  void initState() {
    firstName.text = widget.user.firstName;
    lastName.text = widget.user.lastName;
    email.text = widget.user.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDarkColor,
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: WrapContainer(
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
                                    image: AssetImage(CustomAssets.crossrailtracks,
                                    
                                    ),
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
                              height: 70.h, 
                            ),
                            Row(
                              children: [
                                Text('First Name',
                                    style: CustomTextStyle.klarge.copyWith(
                                        color: CustomColor.kblack,
                                        fontWeight:
                                            CustomFontWeight.kMediumFontWeight)),
                              ],
                            ),
                            SizedBox(
                              child: ProfileTextFeild(
                                controller: firstName,
                                showHideIcon: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter First Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 28.h,
                            ),
                            Row(
                              children: [
                                Text("Last Name",
                                    style: CustomTextStyle.klarge.copyWith(
                                        color: CustomColor.kblack,
                                        fontWeight:
                                            CustomFontWeight.kMediumFontWeight)),
                              ],
                            ),
                            SizedBox(
                              child: ProfileTextFeild(
                                controller: lastName,
                                showHideIcon: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Last Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 28.h,
                            ),
                            Text("Email",
                                style: CustomTextStyle.klarge.copyWith(
                                    color: CustomColor.kblack,
                                    fontWeight:
                                        CustomFontWeight.kMediumFontWeight)),
                            SizedBox(
                              child: ProfileTextFeild(
                                readonly: true,
                                controller: email,
                                showHideIcon: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter EmailAddress';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 53.h,
                            ),
                            Center(
                                child: CustomElevatedButton(
                              iconUrl: CustomAssets.updateicon,
                              title: 'Update',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  //Function to update UserModel 
                                  bool isUpdated = await AuthController()
                                      .updateUserDetails(
                                          userModel: UserModel(
                                              email: email.text,
                                              firstName: firstName.text,
                                              lastName: lastName.text,
                                              password: widget.user.password));
                                }
                              },
                            )),
                            SizedBox(
                              height: 250.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
