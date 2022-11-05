// ignore_for_file: file_names, non_constant_identifier_names, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/station_controller.dart';

class BusTab extends StatefulWidget {
  const BusTab({
    super.key,
  });

  @override
  State<BusTab> createState() => _BusTabState();
}

class _BusTabState extends State<BusTab> {
  var Busstations = Get.put(StationsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Busstations.mstations_loading.isTrue
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Busstations.BusStations.isEmpty
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
                    itemBuilder: ((context, index) {
                      final station = Busstations.BusStations[index];

                      return InkWell(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${station.Name}'
                                    ' '
                                    '${station.Number}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black)),
                                Text('${station.Distance.toPrecision(2)}km',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
          ));
  }
}
