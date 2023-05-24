// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Profile/change_password_screen.dart';
import 'package:sekkah_app/Profile/edit_profile_screen.dart';
import 'package:sekkah_app/Profile/help_center.dart';
import 'package:sekkah_app/Profile/widgets/custom_appbar.dart';
import 'package:sekkah_app/Profile/widgets/custom_elevated_button.dart';
import 'package:sekkah_app/Profile/widgets/profile_button.dart';

import 'package:sekkah_app/data/assets.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';
import 'package:sekkah_app/helpers/user_model.dart';
import 'package:sekkah_app/others/auth_controller.dart';

import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blueDarkColor,
        
        appBar: const CustomAppBar(
          title: 'My Profile',
          showBack: false,
        ),
        body: _auth.currentUser!.uid == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _auth.currentUser!.isAnonymous
                ? const Center(child: Text('No user'))
                :
                //Stream Builder is Used To stream data to get current user .
                StreamBuilder<UserModel>(
                    stream: _firestore
                        .collection('Passenger') //from passengers collection
                        .doc(_auth.currentUser!.uid)
                        .snapshots()
                        .map((event) => UserModel.fromMap(event.data() as Map<
                            String,
                            dynamic>)), //Converting data from stream to Usermodel
                    builder: (context, snapshot) {
                      //Check State, If is Waiting  show Circular Indicator
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      UserModel? user =
                          snapshot.data!; // Snapshot to UserModel
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 30.h,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xffFAFAFA).withOpacity(0.98),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40.r),
                                  topLeft: Radius.circular(40.r),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                  margin: EdgeInsets.only(top: 116.h),
        height: 97.h,
        width: Get.width,
        decoration: const  BoxDecoration(
            image:  DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(CustomAssets.railtracks),
               )),),
                                  Column(children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 30.h),
                                      child:
                                           SizedBox(
                                              height: 123.h,
                                              width: 123.h,
                                              child: 
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.asset(
                                                    "assets/icons/User-icon.png"),
                                              ),
                                            )
                                         
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                        '${user.firstName} ${user.lastName}', // User Name
                                        style: CustomTextStyle.kheading3.copyWith(
                                            color: CustomColor.klightblue,
                                            fontWeight: CustomFontWeight
                                                .kSemiBoldFontWeight
                                              ,
                                                ),
                                                textAlign: TextAlign.center,
                                                ),
                                    Text(user.email,
                                        style: CustomTextStyle.klarge.copyWith(
                                          color: CustomColor.klightblue,
                                          fontWeight:
                                              CustomFontWeight.kLightFontWeight,
                                          decoration: TextDecoration.underline,
                                        )),
                                    SizedBox(height: 22.h),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40.h,
                                      color: CustomColor.kgrey,
                                      padding: EdgeInsets.only(left: 19.h),
                                      child: Text('Account Settings',
                                          style: CustomTextStyle.kheading6.copyWith(
                                              color: CustomColor.kWhite,
                                              fontWeight: CustomFontWeight
                                                  .kSemiBoldFontWeight)),
                                    ),
                                    ProfileButton(
                                      imageurl: CustomAssets.editprofile,
                                      title: 'Edit Profile',
                                      onPressed: () {
                                        //Going To Edit Profile Screen
                                        Get.to(() => EditProfileScreen(
                                              user: user,
                                            ));
                                      },
                                    ),
                                    ProfileButton(
                                      imageurl: CustomAssets.changepassicon,
                                      title: 'Change Password',
                                      onPressed: () {
                                        //Going To Change Password Screen
                                        Get.to(() => ChangePasswordScreen(
                                              user: user,
                                            ));
                                      },
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40.h,
                                      color: CustomColor.kgrey,
                                      padding: EdgeInsets.only(left: 19.h),
                                      child: Text('Other',
                                          style: CustomTextStyle.kheading6.copyWith(
                                              color: CustomColor.kWhite,
                                              fontWeight: CustomFontWeight
                                                  .kSemiBoldFontWeight)),
                                    ),
                                    ProfileButton(
                                      imageurl: CustomAssets.helpcentericon,
                                      title: 'Help Center',
                                      onPressed: () {
                                        Get.to(() => const HelpCenter());
                                      },
                                    ),
                                    SizedBox(
                                      height: 65.h,
                                    ),
                                    CustomElevatedButton(
                                      iconUrl: CustomAssets.logouticon,
                                      title: 'Logout',
                                      onPressed: () {
                                        AuthController().signOut();//Loging Out
                                      },
                                    ),
                                    SizedBox(
                                      height: 100.h,
                                    )
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }));
  }
}
