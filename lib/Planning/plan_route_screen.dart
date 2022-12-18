// ignore_for_file: unused_import

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sekkah_app/constants/app_icons.dart';
import 'package:sekkah_app/constants/app_text_styles.dart';
import 'package:sekkah_app/Planning/components/trip_duration_box.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'components/ticket_widget.dart';

class PlanRouteScreen extends StatefulWidget {
  const PlanRouteScreen({Key? key}) : super(key: key);

  @override
  State<PlanRouteScreen> createState() => _PlanRouteScreenState();
}

class _PlanRouteScreenState extends State<PlanRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueDarkColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Select a route',
          style: poppinsMedium.copyWith(
            fontSize: 18.0,
            color: AppColors.whiteColor,
          ),
        ),
      ),

      /// body
      body: SizedBox(
        height: height(context),
        width: width(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// top box
            SizedBox(height: height(context) * 0.024),
            Container(
              width: width(context),
              margin: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
              padding: EdgeInsets.only(
                left: height(context) * 0.016,
                top: height(context) * 0.016,
                right: height(context) * 0.024,
                bottom: height(context) * 0.032,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.whiteColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.fromIcon),
                      SvgPicture.asset(AppIcons.vertSmallLine),
                      SvgPicture.asset(AppIcons.toIcon),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                maxLines: 1,
                                style: poppinsRegular.copyWith(
                                  fontSize: 12.0,
                                  color: AppColors.greyLightColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'King Saud University',
                                maxLines: 1,
                                style: poppinsMedium.copyWith(
                                  fontSize: 14.0,
                                  color: AppColors.blueDarkColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height(context) * 0.015),
                          child: Divider(
                            color: AppColors.greyLightColor.withOpacity(0.3),
                            height: 1,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'To',
                                maxLines: 1,
                                style: poppinsRegular.copyWith(
                                  fontSize: 12.0,
                                  color: AppColors.greyLightColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'King Abdullah Financial District',
                                maxLines: 1,
                                style: poppinsMedium.copyWith(
                                  fontSize: 14.0,
                                  color: AppColors.blueDarkColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(context) * 0.04),

            /// trip duration area
            Expanded(
              child: Container(
                width: width(context),
                padding:
                    EdgeInsets.symmetric(horizontal: height(context) * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0xffFAFAFA).withOpacity(0.98),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// pin point
                    SizedBox(height: height(context) * 0.024),
                    Center(
                      child: Container(
                        height: 5.0,
                        width: height(context) * 0.045,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    ),

                    ///
                    SizedBox(height: height(context) * 0.02),
                    Text(
                      'Trip duration:',
                      style: poppinsMedium.copyWith(
                        fontSize: 16,
                        color: AppColors.blueDarkColor,
                      ),
                    ),

                    /// boxes
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        padding: const EdgeInsets.only(bottom: 50),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return const TripDurationBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
