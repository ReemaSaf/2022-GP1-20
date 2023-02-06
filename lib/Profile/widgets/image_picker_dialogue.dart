

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekkah_app/data/typography.dart';



class ImagePickDialog extends StatelessWidget {
  final VoidCallback cameraCallback;
  final VoidCallback galleryCallback;
  const ImagePickDialog({
    Key? key,
    required this.cameraCallback,
    required this.galleryCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Image", style: CustomTextStyle.kmedium),
      content: SizedBox(
        height: 100.h,
        child: Column(children: [
          InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: cameraCallback,
            child: Row(
              children: [
                const Icon(Icons.camera),
                SizedBox(width: 5.w),
                Text(
                  "Select Image from Camera",
                  style: CustomTextStyle.kmedium,
                )
              ],
            ),
          ),
          SizedBox(height: 30.h),
          InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: galleryCallback,
            child: Row(
              children: [
                const Icon(Icons.photo),
                SizedBox(width: 5.w),
                Text(
                  "Select Image from Gallery",
                  style: CustomTextStyle.kmedium,
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}