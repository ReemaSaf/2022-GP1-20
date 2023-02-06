import 'dart:core';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// This class represents the entire app's typography
class CustomTextStyle {
  /// Font Size = 48
  static TextStyle get kheading1 =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(56));

  /// Font Size = 40
  static TextStyle get kheading2 =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(40));

  /// Font Size =32, default heading
  static TextStyle get kheading3 =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(32));

  /// Font Size =24, default heading
  static TextStyle get kheading4 => GoogleFonts.poppins(
      textStyle: TextStyle(fontSize: ScreenUtil().setSp(24)));

  /// Font Size =20, default heading
  static TextStyle get kheading5 =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(20));

  /// Font Size =18, default heading
  static TextStyle get kheading6 =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(18));

  /// Font Size =16, default heading
  static TextStyle get klarge =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(16));

  /// Font Size =14, default heading
  static TextStyle get kmedium =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(14));

  /// Font Size =12, default heading
  static TextStyle get ksmall =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(12));

  /// Font Size =10, default heading
  static TextStyle get kxsmall =>
      GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(10));
}

class CustomFontWeight {
  static FontWeight kThinFontWeight = FontWeight.w100;
  static FontWeight kExtraLightFontWeight = FontWeight.w200;
  static FontWeight kLightFontWeight = FontWeight.w300;
  static FontWeight kRegularWeight = FontWeight.w400;
  static FontWeight kMediumFontWeight = FontWeight.w500;
  static FontWeight kSemiBoldFontWeight = FontWeight.w600;
  static FontWeight kBoldFontWeight = FontWeight.w700;
  static FontWeight kExtraBoldFontWeight = FontWeight.w800;
  static FontWeight kBlackFontWeight = FontWeight.w900;
}
