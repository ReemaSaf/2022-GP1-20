import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/constants/app_colors.dart';
import 'package:sekkah_app/constants/app_text_styles.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool? showBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBack = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: showBack!
          ? InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: CustomColor.kWhite,
              ))
          : const SizedBox.shrink(),
      elevation: 0, 
      centerTitle: true,// to remove shadow and bar background
      title: Text(
          title,
          style: poppinsMedium.copyWith(
              fontSize: 24.sp,
              fontWeight: CustomFontWeight.kSemiBoldFontWeight,
               color: AppColors.whiteColor),
        ),
    );
  }

  @override
  // ignore: todo
  // TODO: implement preferredSize
  // Size get preferredSize => throw UnimplementedError();

  @override
  // ignore: todo
  // TODO: implement preferredSize
  // it's a getter function for bar height with -- PreferredSizeWidget
  Size get preferredSize => Size.fromHeight(50.h);
}
