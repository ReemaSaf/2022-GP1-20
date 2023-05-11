// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names, depend_on_referenced_packages, unused_import, avoid_print, library_private_types_in_public_api, unnecessary_new, unnecessary_brace_in_string_interps
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
    required this.routeTime,
    required this.route,
  }) : super(key: key);

  final String start;
  final String end;
  final DateTime date;
  final int tickets;
  final String username;
  final String routeTime;
  final List<RouteModel> route;

  @override
  State<TripDurationBox> createState() => _TripDurationBoxState();
}

class _TripDurationBoxState extends State<TripDurationBox> {
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  late var inputDate = inputFormat.parse(
      '${widget.date.day}/${widget.date.month}/${widget.date.year} ${widget.date.hour}:${widget.date.minute}');
  var outputFormat = DateFormat('dd MMM');
  DateTime now = new DateTime.now();
  late var currentDate = outputFormat.format(now);
  late var outputDate = outputFormat.format(inputDate);
  late var arrivalTime = DateFormat('HH:mm a').format(inputDate);
  // late var checkTime = DateFormat('HH:mm').parse('${widget.date.hour}:${widget.date.minute}');
  // late var currentTime = DateFormat('HH:mm').parse('${now.hour-1}:${now.minute}');
  double currentTime=(DateTime.now().hour+1) + DateTime.now().minute/60.0;
  late double checkTime;

  var dapartureTime = "";

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    checkTime=widget.date.hour + widget.date.minute/60.0;
    if (widget.routeTime.contains("m")) {
      dapartureTime = DateFormat('HH:mm a').format(widget.date
          .add(Duration(minutes: int.parse(widget.routeTime.split(" ")[0]))));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height(context) * 0.02),
      child: TicketWidget(
        width: width(context),
        height: 380,
        isCornerRounded: true,
        //padding: EdgeInsets.all(10),
        color: AppColors.whiteColor,
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: width(context),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Color.fromARGB(95, 80, 177, 204),
              ),
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
                    InkWell(
                      onTap: () {
                        print("===================================== ${currentTime} oooo $checkTime");
                        if (currentDate == outputDate) {
                          if(checkTime==currentTime || currentTime>checkTime){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Tracking(
                                          route: widget.route,
                                          time: widget.routeTime,
                                        )));
                          }

                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.blueDarkColor,
                            ),
                            borderRadius: BorderRadius.circular(18)),
                        child: Row(
                          children: [
                            Text(
                              "Start",
                              style: poppinsSemiBold.copyWith(
                                fontSize: 15,
                                color: AppColors.blueDarkColor,
                              ),
                            ),
                            const Icon(
                              Icons.near_me,
                              color: AppColors.blueDarkColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: prefer_const_constructors

                    Text(
                      'Departure',
                      style: poppinsMedium.copyWith(
                        fontSize: 14.0,
                        color: AppColors.greyDarkColor,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Arrival',
                      style: poppinsMedium.copyWith(
                        fontSize: 14.0,
                        color: AppColors.greyDarkColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: prefer_const_constructors

                    Text(
                      arrivalTime,
                      style: poppinsMedium.copyWith(
                        fontSize: 24.0,
                        color: AppColors.skyColor,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      dapartureTime,
                      style: poppinsMedium.copyWith(
                        fontSize: 24.0,
                        color: AppColors.skyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 23,
                      //width: 320,
                      child: Image.asset(
                        'assets/icons/traincomponent.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 29,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: prefer_const_constructors

                    SizedBox(
                      width: .35.sw,
                      height: .2.sw,
                      child: Text(
                        textAlign: TextAlign.center,
                        widget.start,
                        style: poppinsMedium.copyWith(
                          fontSize: 14.0,
                          color: AppColors.blueDarkColor,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    SizedBox(
                      width: .35.sw,
                      height: .2.sw,
                      child: Text(
                        widget.end,
                        textAlign: TextAlign.center,
                        style: poppinsMedium.copyWith(
                          fontSize: 14.0,
                          color: AppColors.blueDarkColor,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          Text(
                            'Passenger',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 14,
                              color: AppColors.skyColor,
                            ),
                          ),
                          Text(
                            widget.username,
                            style: poppinsSemiBold.copyWith(
                              fontSize: 12,
                              color: AppColors.blueDarkColor,
                            ),
                          ),
                        ]),
                        Column(children: [
                          Text(
                            'Date',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 14,
                              color: AppColors.skyColor,
                            ),
                          ),
                          Text(
                            outputDate,
                            style: poppinsSemiBold.copyWith(
                              fontSize: 12,
                              color: AppColors.blueDarkColor,
                            ),
                          ),
                        ]),
                        Column(children: [
                          Text(
                            'Tickets',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 14,
                              color: AppColors.skyColor,
                            ),
                          ),
                          Text(
                            widget.tickets.toString(),
                            style: poppinsSemiBold.copyWith(
                              fontSize: 12,
                              color: AppColors.blueDarkColor,
                            ),
                          ),
                        ]),
                      ]),
                ),

                // ------------------------ QR CODE
              ]),
            ),
          ],
        ),
      ),
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
            // borderRadius: widget.isCornerRounded
            //     ? BorderRadius.circular(20.0)
            //     : BorderRadius.circular(0.0),
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
        center: Offset(0.8, size.height / 1.2),
        radius: 10.0,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 1.2),
        radius: 10.0,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
