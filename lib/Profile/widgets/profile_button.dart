import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';



class ProfileButton extends StatelessWidget {
  final String imageurl;
  final String title;
  final VoidCallback onPressed;
  const ProfileButton({
    Key? key,
    required this.imageurl,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 50.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 21.h,
                  width: 24.h,
                  child: Image.asset(
                    imageurl,
                    //color: CustomColor.kprimaryblue,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(title,
                    style: CustomTextStyle.klarge.copyWith(
                        color: CustomColor.kprimaryblue,
                        fontWeight: CustomFontWeight.kMediumFontWeight)),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: CustomColor.kprimaryblue,
                  size: 18.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
