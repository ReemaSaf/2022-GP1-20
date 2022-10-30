import 'package:flutter/material.dart';
import 'package:sekkah_app/others/background.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelWidget extends StatelessWidget{
final ScrollController controller;
final PanelController panelController;

const PanelWidget({
Key? key,
required this.controller,
required this.panelController,
}) : super(key: key);


@override
Widget build(BuildContext context) => ListView(
  padding: EdgeInsets.zero,
  controller: controller,
  children: <Widget>[
    const SizedBox(height: 12),
    buildDragHandle(),
    const SizedBox(height: 15),
    buildAboutText(),
    const SizedBox(height: 24),
    
  ],
);

 Widget buildDragHandle() => GestureDetector(
 // ignore: sort_child_properties_last
 child: Center(
    child: Container(
    width: 30,
    height:5,
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



Widget buildAboutText()=> Container(
padding: const EdgeInsets.symmetric(horizontal: 24),
child: Column(
crossAxisAlignment:CrossAxisAlignment.start,
children: const <Widget>[
  Text(
    'Nearby Stations',
    style: TextStyle(fontSize: 30, color: Color.fromRGBO(39, 58, 105, 1) ,
      fontWeight: FontWeight.w600),
  ),
  SizedBox(height: 12),
  Text(
    'fbfbfbfbfbfbbf',
  ),
],
),

);

 

}