import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';

class CustomElevatedButton extends StatelessWidget {
  final String iconUrl;
  final String title;
  final VoidCallback onPressed;
  const CustomElevatedButton({
    Key? key,
    required this.iconUrl,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 253.w,
      height: 50.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColor.kprimaryblue,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24.h,
                width: 24.h,
                child: SvgPicture.asset(
                 iconUrl,
                  //color: CustomColor.kprimaryblue,
                ),
              ),
              SizedBox(
                width: 13.w,
              ),
              Text(title,
                  style: CustomTextStyle.kheading5.copyWith(
                      color: CustomColor.kWhite,
                      fontWeight: CustomFontWeight.kMediumFontWeight)),
            ],
          )),
    );
  }
}
