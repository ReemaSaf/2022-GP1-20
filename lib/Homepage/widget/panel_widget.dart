import 'package:flutter/material.dart';
import 'package:sekkah_app/Homepage/widget/TabSection.dart';
import 'package:sekkah_app/others/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        controller: controller,
        children: <Widget>[
          const SizedBox(height: 12),
          buildDragHandle(),
          const SizedBox(height: 5),
          buildAboutText(),
          builTabSection(context),
        ],
      );

  Widget buildAboutText() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            SizedBox(height: 9),
            Text(
              'Nearby Stations',
              // textAlign: TextAlign.right,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 30, color: blueColor),
            ),
            SizedBox(height: 12),
          ],
        ),
      );

  Widget buildDragHandle() => GestureDetector(
        // ignore: sort_child_properties_last
        child: Center(
          child: Container(
            width: 50,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onTap: togglePanel,
      );

  void togglePanel() {
    panelController.panelPosition.round() == 1
        ? panelController.close()
        : panelController.open();
  }

  builTabSection(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: const TabSection(),
    );
  }
}
