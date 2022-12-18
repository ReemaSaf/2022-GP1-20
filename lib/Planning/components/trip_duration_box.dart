import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sekkah_app/Planning/components/ticket_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class TripDurationBox extends StatefulWidget {
  const TripDurationBox({Key? key}) : super(key: key);

  @override
  State<TripDurationBox> createState() => _TripDurationBoxState();
}

class _TripDurationBoxState extends State<TripDurationBox> {

  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height(context) * 0.02),
      child: Bounceable(
        onTap: (){
          setState(() {
            isClick = !isClick;
          });
        },
        child: TicketWidget(
          width: width(context),
          height: height(context) * 0.17,
          isCornerRounded: true,
          padding: const EdgeInsets.all(10),
          color: isClick == true ?  AppColors.skyColor : AppColors.whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '25',
                    style: poppinsMedium.copyWith(
                      fontSize: 24.0,
                      color: isClick == true ?  AppColors.whiteColor : AppColors.skyColor,
                    ),
                  ),
                  const SizedBox(width: 3.0),
                  Text(
                    'Min',
                    style: poppinsMedium.copyWith(
                      fontSize: 14.0,
                      color: isClick == true ?  AppColors.whiteColor : AppColors.blueDarkColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height(context) *0.02),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcons.departureIcon),
                            const Expanded(
                              child: DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: AppColors.greyColor,
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                                dashGapColor: Colors.transparent,
                                dashGapRadius: 0.0,
                              ),
                            ),
                            SvgPicture.asset(AppIcons.arrivalIcon),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text('13.10pm',
                              style: poppinsRegular.copyWith(
                                fontSize: 12.0,
                                color: isClick == true ?  AppColors.whiteColor : AppColors.blueDarkColor,
                              ),
                            ),
                          ),
                          Text('13.35pm',
                            style: poppinsRegular.copyWith(
                              fontSize: 12.0,
                              color: isClick == true ?  AppColors.whiteColor : AppColors.skyColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height(context) * 0.04),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text('departure',
                                style: poppinsRegular.copyWith(
                                  fontSize: 12.0,
                                  color: isClick == true ?  AppColors.whiteColor : AppColors.greyDarkColor,
                                ),
                              ),
                            ),
                            Text('arrival',
                              style: poppinsRegular.copyWith(
                                fontSize: 12.0,
                                color: isClick == true ?  AppColors.whiteColor : AppColors.greyDarkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SvgPicture.asset(AppIcons.vanIcon, color: isClick == true ?  AppColors.whiteColor : AppColors.greyDarkColor,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Details',
                  style: poppinsSemiBold.copyWith(
                    fontSize: 14.0,
                    color: isClick == true ?  AppColors.whiteColor : AppColors.skyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}