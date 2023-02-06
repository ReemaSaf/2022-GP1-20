// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';

class ProfileTextFeild extends StatefulWidget {
  bool? obscuretext;
  final TextEditingController controller;
  final bool showHideIcon;
  final String? Function(String?)? validator;
  final bool? readonly;

  ProfileTextFeild({
    Key? key,
    this.obscuretext = false,
    required this.controller,
    required this.showHideIcon,
    this.validator,
    this.readonly = false,
  }) : super(key: key);

  @override
  _ProfileTextFeildState createState() => _ProfileTextFeildState();
}



class _ProfileTextFeildState extends State<ProfileTextFeild> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscuretext!,
      readOnly: widget.readonly!,
      controller: widget.controller,
      validator: widget.validator,
      style: TextStyle(
          fontSize: 16.sp,
          fontWeight: CustomFontWeight.kLightFontWeight,
          color: CustomColor.kblack),
      decoration: InputDecoration(
        constraints: BoxConstraints(minHeight: 40.h, maxHeight: 180.h),
        errorMaxLines: 4,
        errorStyle: TextStyle(fontSize: 18.sp),
        suffixIcon: widget.showHideIcon
            ? widget.obscuretext!
                ? InkWell(
                    onTap: () {
                      setState(() {
                        widget.obscuretext = !widget.obscuretext!;
                      });
                    },
                    child: Icon(Icons.visibility_off_outlined,
                        color: CustomColor.kblack, size: 18.sp))
                : InkWell(
                    onTap: () {
                      setState(() {
                        widget.obscuretext = !widget.obscuretext!;
                      });
                    },
                    child: Icon(
                      Icons.visibility_outlined,
                      color: CustomColor.kblack,
                      size: 18.sp,
                    ))
            : widget.readonly! ? const SizedBox.shrink():Icon(Icons.edit,
                              size: 16.sp,
                              color: CustomColor.kblack ,
                              ),
        hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: CustomFontWeight.kLightFontWeight,
            color: CustomColor.kblack),
        fillColor: Colors.transparent,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.kblack),
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.kblack),
            borderRadius: BorderRadius.circular(8)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.kblack),
            borderRadius: BorderRadius.circular(8)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: CustomColor.kblack),
            borderRadius: BorderRadius.circular(8)),
      ),
      cursorColor: CustomColor.kblack,
    );
  }
}
