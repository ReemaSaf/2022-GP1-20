// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/station_controller.dart';
import 'BusTab.dart';
import 'MetroTab.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var Busstations = Get.put(StationsController());
  @override
  void initState() {
    Busstations.get_bus_stations();
    Busstations.get_Metro_stations();
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
              children: const [BusTab(), MetroTab()],
            )),
          ],
        ));
  }
}
