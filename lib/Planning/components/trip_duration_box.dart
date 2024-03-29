// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:sekkah_app/Planning/components/ticket_widget.dart';
import 'package:sekkah_app/constants/app_icons.dart';

import '../../RoutMap.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';
import '../../helpers/route_model.dart';

class TripDurationBox extends StatefulWidget {
  const TripDurationBox({
    Key? key,
    required this.duration,
    required this.distance,
    this.exproute,
    this.index,
    required this.selectedindex,
    this.color,
  }) : super(key: key);

  final String duration;
  final String distance;
  final List<RouteModel>? exproute;
  final int? index;
  final int selectedindex;
  final Color? color;

  @override
  State<TripDurationBox> createState() => _TripDurationBoxState();
}

class _TripDurationBoxState extends State<TripDurationBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height(context) * 0.02),
      child: TicketWidget(
        width: width(context),
        height: 168.h,
        isCornerRounded: true,
        padding: EdgeInsets.all(10.h),
        color:widget.color!,
        onPressed: () {
          print("you tappped it  ");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.duration.toString(),
                  style: poppinsMedium.copyWith(
                    fontSize: 14.0,
                    color: Colors.green[900],
                  ),
                ),
                SizedBox(width: 3.h),
                Text(
                  widget.distance.toString(),
                  style: poppinsMedium.copyWith(
                    fontSize: 24.0,
                    color: AppColors.blueDarkColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              height: 24.h,
              width: 320.w,
              child: Image.asset(
                AppIcons.ticketcomponent,
                fit: BoxFit.fitWidth,
              ),
            )
            ,
            SizedBox(
              height: 30.h,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RouteMap(route: widget.exproute!,routeNo:widget.selectedindex,)));
              },
              child: Text(
                'Details',
                style: poppinsSemiBold.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.skyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}