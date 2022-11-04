// ignore_for_file: file_names, non_constant_identifier_names, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/station_controller.dart';

class BusTab extends StatefulWidget {
  const BusTab({super.key});

  @override
  State<BusTab> createState() => _BusTabState();
}

class _BusTabState extends State<BusTab> {
  var Busstations = Get.put(StationsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Busstations.stations_loading.isTrue
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Busstations.BusStations.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          "No Bus Station Found",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: Busstations.BusStations.length,
                    itemBuilder: ((context, index) => InkWell(
                          onTap: () {
                            Busstations.get_bus_stations();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${Busstations.BusStations[index]['Name']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black45)),
                                  // Text(
                                  //     '${Busstations.BusStations[index]['Type']}',
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .subtitle1!
                                  //         .copyWith(color: Colors.black45)),
                                ],
                              ),
                            ),
                          ),
                        ))),
          ));
  }
}
