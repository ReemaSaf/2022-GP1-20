// ignore_for_file: non_constant_identifier_names, file_names, unnecessary_string_interpolations, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/helpers/DistanceModel.dart';
import '../../helpers/station_controller.dart';

class MetroTab extends StatefulWidget {
  final Function(DistanceModel, String) onStationClicked;

  const MetroTab({super.key, required this.onStationClicked});

  @override
  State<MetroTab> createState() => _MetroTabState();
}

class _MetroTabState extends State<MetroTab> {
  var Busstations = Get.put(StationsController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Busstations.mstations_loading.isTrue
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey.shade100,
            body: Busstations.MetroStations.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          "No Metro Station Found",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: Busstations.MetroStations.length,
                    itemBuilder: ((context, index) {
                      final station = Busstations.MetroStations[index];
                      return InkWell(
                        onTap: () {
                          widget.onStationClicked(station, 'Station');
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${station.Name}',
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
