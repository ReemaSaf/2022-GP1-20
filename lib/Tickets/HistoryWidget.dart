// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, depend_on_referenced_packages, unused_import, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, library_private_types_in_public_api, unnecessary_new, unnecessary_brace_in_string_interps
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Planning/widgets/search_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../helpers/route_model.dart';
import '../services/tracking.dart';
import 'Ticket1.dart';

class TripDurationBox extends StatefulWidget {
  const TripDurationBox({
    Key? key,
    required this.start,
    required this.end,
    required this.date,
    required this.tickets,
    required this.username,
    required this.originLatLong,
    required this.destinationLatLang,
    required this.routeNo,
    required this.timeTaken,
  }) : super(key: key);

  final String start;
  final String end;
  final DateTime date;
  final int tickets;
  final String username;
  final List destinationLatLang;
  final List originLatLong;
  final int routeNo;
  final String timeTaken;

  @override
  State<TripDurationBox> createState() => _TripDurationBoxState();
}

class _TripDurationBoxState extends State<TripDurationBox> {
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  late var inputDate = inputFormat.parse(
      '${widget.date.day}/${widget.date.month}/${widget.date.year} ${widget.date.hour}:${widget.date.minute}');
  var outputFormat = DateFormat('dd MMM');
  late var outputDate = outputFormat.format(inputDate);
  var showFormat = DateFormat('dd MMM HH:mm');
  late var showDate=showFormat.format(inputDate);
  DateTime now = new DateTime.now();
  late var currentDate = outputFormat.format(now);
  var isActive = false;
  List<List<RouteModel>> routeListList = [];
  bool isLoading = false;
  late double checkTime;
  double currentTime = (DateTime.now().hour) + DateTime.now().minute / 60.0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    checkTime = widget.date.hour-1 + widget.date.minute / 60.0;
    isActive = widget.date.isAfter(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: height(context) * 0.03,
          ),
          child: TicketWidget(
            width: width(context),
            height: 200,
            isCornerRounded: true,
            color: AppColors.whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: width(context),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Color.fromARGB(95, 80, 177, 204),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'SEKKAH',
                            style: poppinsBold.copyWith(
                              fontSize: 20.0,
                              color: AppColors.skyColor,
                            ),
                          ),
                          Row(children: [
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isActive ? Colors.green : Colors.red,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                  color: isActive
                                      ? Colors.green[100]
                                      : Colors.red[100]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Text(
                                      isActive ? "Active" : 'Expired',
                                      style: poppinsSemiBold.copyWith(
                                        fontSize: 12,
                                        color: isActive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          isActive
                              ? InkWell(
                                  onTap: () async {
                                    print(
                                        "===================================== ${currentTime} oooo $checkTime");
                                    print(
                                        "===============================================${currentTime - checkTime}");
                                    print("this is the date %%%%%%%%%%%%%%%%%%%%%%%%%%%% c $currentDate o $outputDate");
                                    if(currentDate == outputDate){
                                      print("same date %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55");
                                      if(checkTime - currentTime == 1 ||
                                          checkTime - currentTime < 0){
                                        setState(() {
                                          isLoading = true;
                                        });
                                        print("%%%%%%%%%%%%%%%%%%%%%%%%5 this is the route ${routeListList.length}");
                                        await createRoute(
                                          originLatLong: widget.originLatLong,
                                          originAddress: widget.start,
                                          destinationLatLang:
                                          widget.destinationLatLang,
                                          destinationAddress: widget.end,
                                        ).then((value) {
                                          setState(() {
                                            routeListList = value;
                                          });
                                          setState(() {
                                            isLoading = false;
                                          });
                                          print("this is the route ${routeListList.length}");

                                          if (currentDate == outputDate) {
                                            if (checkTime - currentTime == 1 ||
                                                checkTime - currentTime < 0) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Tracking(
                                                            route: routeListList[
                                                            widget.routeNo],
                                                            time: widget.timeTaken,
                                                          )));

                                            } else {
                                              Get.snackbar('Alert', 'Tracking will be available one hour ahead of your trip',
                                                  colorText: Colors.white,
                                                  backgroundColor:
                                                  const Color.fromARGB(255, 204, 84, 80));
                                            }
                                          }
                                        });
                                      }else{
                                        Get.snackbar('Alert', 'Tracking will be available one hour ahead of your trip',
                                            colorText: Colors.white,
                                            backgroundColor:
                                            const Color.fromARGB(255, 204, 84, 80));
                                      }
                                    }else{
                                      Get.snackbar('Alert', 'Tracking will be available one hour ahead of your trip',
                                          colorText: Colors.white,
                                          backgroundColor:
                                          const Color.fromARGB(255, 204, 84, 80));
                                    }

                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff50B2CC)),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Start",
                                          style: poppinsSemiBold.copyWith(
                                            fontSize: 12,
                                            color: AppColors.skyColor,
                                          ),
                                        ),
                                        const Icon(Icons.near_me,
                                            color: Color(0xff50B2CC)),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14, top: 10),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ignore: prefer_const_constructors

                          Text(
                            'Departure',
                            style: poppinsMedium.copyWith(
                              fontSize: 12.0,
                              color: AppColors.greyDarkColor,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Arrival',
                            style: poppinsMedium.copyWith(
                              fontSize: 12.0,
                              color: AppColors.greyDarkColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ignore: prefer_const_constructors
                        SizedBox(
                          width: .15.sw,
                          height: .15.sw,
                          child: Text(
                            widget.start,
                            style: const TextStyle(overflow: TextOverflow.clip),
                          ),
                        ),


                        SizedBox(
                          height: 14,
                          child: Image.asset(
                            'assets/icons/traincomponent.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          width: .15.sw,
                          height: .15.sw,
                          child: Text(
                            widget.end,
                            style: const TextStyle(overflow: TextOverflow.clip),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.5),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.greyColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(Icons.account_circle_outlined,
                                        size: 20, color: AppColors.skyColor),
                                    Container(
                                      width: 15,
                                      child: Text(
                                        widget.tickets.toString(),
                                        style: poppinsSemiBold.copyWith(
                                          fontSize: 12,
                                          color: AppColors.skyColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                              Container(
                                width: 115,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.greyColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.timer_sharp,
                                        size: 20, color: AppColors.skyColor),
                                    Container(
                                      width: 80,
                                      child: Text(
                                        showDate,
                                        style: poppinsSemiBold.copyWith(
                                          fontSize: 11,
                                          color: AppColors.blueDarkColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ]),
                    ),
                    const SizedBox(height: 5),

                   
                  ]),
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Container(
                child: const Center(
                    child: Padding(
                padding: EdgeInsets.all(60.0),
                child: CircularProgressIndicator(),
              )))
            : const SizedBox(),
      ],
    );
  }
}

class TicketWidget extends StatefulWidget {
  const TicketWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.color = Colors.white,
    this.isCornerRounded = false,
    this.padding,
    this.margin,
    this.shadow,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadow;

  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: InkWell(
        child: Container(
          // ignore: sort_child_properties_last
          child: widget.child,
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            boxShadow: widget.shadow,
            color: widget.color,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
      Rect.fromCircle(
        center: Offset(0.0, size.height / 2),
        radius: 10.0,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2),
        radius: 10.0,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
