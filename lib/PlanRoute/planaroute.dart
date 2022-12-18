// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:multiple_stream_builder/multiple_stream_builder.dart';
// import 'package:sekkah_app/helpers/bus_station_model.dart';
// import 'package:sekkah_app/others/map_controller.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:sekkah_app/Homepage/widget/panel_widget.dart';
// import 'package:sekkah_app/others/constants.dart';
// import '../helpers/metro_station_model.dart';
// import '../others/auth_controller.dart';
//import 'providers/locationProvider.dart';

class PlanARoute extends StatefulWidget {
  const PlanARoute({Key? key}) : super(key: key);

  @override
  State<PlanARoute> createState() => _PlanARoute();
}

class _PlanARoute extends State<PlanARoute> {
  //final panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF273A69),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hi, Passenger! ",
                            style: TextStyle(
                                color: Color.fromARGB(160, 255, 255, 255)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Where would you like to go?",
                            style: TextStyle(
                              color: Color(0xFF50B2CC),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //Current
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF50B2CC),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.location_history,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Current location",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //Destination
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF50B2CC),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Destination",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //Search button
                  Column(children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color(0xFF50B2CC),
                      ),
                      onPressed: () {
                        // ignore: avoid_print
                        print("button is pressed");
                      },
                      child: const Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ])
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
