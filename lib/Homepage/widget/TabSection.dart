// ignore_for_file: file_names, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/helpers/DistanceModel.dart';
import '../../helpers/station_controller.dart';
import '../providers/locationProvider.dart';
import 'BusTab.dart';
import 'MetroTab.dart';

class TabSection extends StatefulWidget {
  Function(DistanceModel, String) onStationClicked;
  TabSection({
    super.key,
    required this.onStationClicked,
  });

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var Busstations = Get.put(StationsController());
  final provider = Get.put(LocationProvider());
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  void _asyncMethod() async {
    await provider.locationFetch(context).then((value) {
      if (value != null) {
        if (Busstations.BusStations.isEmpty) {
          Busstations.get_bus_stations();
          Busstations.get_Metro_stations();
        } else {
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: TabBar(
                  controller: tabController,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.black,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                      color: const Color(0xFF273a69),
                      borderRadius: BorderRadius.circular(15)),
                  tabs: const [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Text(
                        'Bus Station',
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Text(
                        'Metro Station',
                      ),
                    ),
                  ]),
            ),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: [
                BusTab(
                  onStationClicked: widget.onStationClicked,
                ),
                MetroTab(
                  onStationClicked: widget.onStationClicked,
                ),
              ],
            )),
          ],
        ));
  }
}
