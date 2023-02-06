import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Profile/widgets/custom_appbar.dart';
import 'package:sekkah_app/Profile/widgets/custom_wrap.dart';
import 'package:sekkah_app/data/assets.dart';
import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';
import 'package:url_launcher/url_launcher.dart';


import '../constants/app_colors.dart';

class HelpCenter extends StatelessWidget {
  
  const HelpCenter({Key? key, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blueDarkColor,
        appBar: const CustomAppBar(
          title: 'Help Center',
          showBack: true,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.h,
              ),
              Expanded(
                child: WrapContainer(
                  child: Stack(

                    children: [
                      Container(
                                    margin: EdgeInsets.only(top: 500.h),
                            height: 220.h,
                            width: Get.width,
                            decoration: const  BoxDecoration(
                             
                                image:  DecorationImage(
                                    fit:  BoxFit.fitWidth,
                                    image: AssetImage(CustomAssets.crossrailtracks),
                                   )),),
                      Column(
                        children: [
                          SizedBox(height: 30.h,),
                          Text(
              'Contact us for support '    ,
                                    style: CustomTextStyle.kheading5.copyWith(
                                            color: CustomColor.kprimaryblue,
                                            fontWeight:
                                                CustomFontWeight.kSemiBoldFontWeight)),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                      height: 36.h,
                      width: 36.h,
                      child: SvgPicture.asset(
                       CustomAssets.arrowdown
                        //color: CustomColor.kprimaryblue,
                      ),),
                      SizedBox(
                          height: 44.h,
                        ),
                        InkWell(
                          onTap: () async {
          // I add the link in uri , and then Using Url launcher I call this link.
          var url = Uri.parse("https://twitter.com/sekkahsa?s=21&t=IwDOEhH6SEF0naUAEBydvQ");
if (await canLaunchUrl(url)) {
  await launchUrl(url);
} else 
 { Get.snackbar("Something went Wrong", "Could not launch ,Please try later",
       backgroundColor: const Color(0xff50b2cc)
       );
                          }

                          },
                          child: Container(
                            height: 40.h,
                            width: 300.w,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.symmetric(horizontal: 55.h),
                                decoration: BoxDecoration(
                                  color: CustomColor.kgrey,
                                  borderRadius: BorderRadius.circular(8.r)
                                ),
                                padding: EdgeInsets.only(left: 19.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                          height: 24.h,
                                          width: 30.w,
                                          child: SvgPicture.asset(
                                           CustomAssets.twitter
                                          ),),
                                          SizedBox(
                            width: 10.w,
                          ),
                                    Text('Twitter',
                                        style: CustomTextStyle.kheading6.copyWith(
                                            color: CustomColor.kprimaryblue,
                                            fontWeight:
                                                CustomFontWeight.kSemiBoldFontWeight)),
                                  ],
                                ),
                              ),
                        ),
                        
              
                        
                        ],
                      ),
                    ],
                  )
                  
                   ),
              )]));
                    }}