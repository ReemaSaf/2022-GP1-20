import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Register/signup_screen.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import 'package:sekkah_app/others/constants.dart';

const LatLng Khurais_Road = LatLng(24.740946376833584, 46.798506629342775);
const LatLng Al_Hamra = LatLng(24.776695973800166, 46.777197831194556);
const LatLng King_Saud_University =
    LatLng(24.713218882457202, 46.62857961831653);
const LatLng MOE = LatLng(24.740716559819983, 46.694773729870136);
//const LatLng STC = LatLng(24.72665826728583, 46.66700133999424);
const LatLng Ar_Rabi = LatLng(24.78629195996191, 46.66013792585841);
const LatLng King_Abdullah_Financial_District =
    LatLng(24.767467334723097, 46.64305311230236);
const LatLng AlYarmuk = LatLng(24.791197738712103, 46.76626014236253);
const LatLng Qasr_AlHukm = LatLng(24.629451072535158, 46.716342959436645);
const LatLng AlWurud = LatLng(24.728513713582622, 46.66647663657381);
const LatLng STC = LatLng(24.72780279168026, 46.66402971583957);
const LatLng An_Nuzhah = LatLng(24.748232849680114, 46.712524046659894);
const LatLng Ad_Douh = LatLng(24.582687500762187, 46.58829571230235);
const LatLng DK = LatLng(24.724035388519273, 46.655157716642734);
const LatLng DK2 = LatLng(24.722173718445912, 46.861130749011366);
const LatLng AlRajih_Grand_Mosque =
    LatLng(24.680257767875453, 46.779516666456296);
const LatLng Uthman_bin_Affan_Road =
    LatLng(24.801506858888473, 46.69584175608972);
const LatLng King_Salman_Oasis = LatLng(24.717206999063556, 46.638721784925124);
const LatLng Tuwaiq = LatLng(24.585613556916503, 46.559645359137875);
const LatLng Granada = LatLng(24.786596609860684, 46.72914975780418);
const LatLng King_Abdulaziz_Road =
    LatLng(24.736628468553576, 46.68478428663959);
const LatLng Harun_AlRasheed = LatLng(24.686316094328742, 46.796254400133380);
const LatLng King_Abdullah_Road = LatLng(24.717141214300362, 46.63876470013338);
const LatLng AlImam_Hospital = LatLng(24.603644941107355, 46.73439692896878);
const LatLng King_Khalid_Airport_Terminal_1_2 =
    LatLng(24.96141030360308, 46.69874671804878);
const LatLng King_Khalid_Airport_Terminal_3_4 =
    LatLng(24.956036305639092, 46.70235151960153);
const LatLng Hassan_Ibn_Tahit_Street =
    LatLng(24.713138180079678, 46.84747031001042);
const LatLng West_Station = LatLng(24.582103836933722, 46.61461664702924);
const LatLng AlSahafah = LatLng(24.81208798511673, 46.62570426013289);
const LatLng Khalid_Ibn_AlWaleed_Road =
    LatLng(24.768429239510585, 46.75873393175022);
const LatLng National_Museum = LatLng(24.646564430167828, 46.714283855042105);
const LatLng Dhahrat_AlBadiah = LatLng(24.606826444552556, 46.65386732824994);
//const LatLng DK4 = LatLng(24.60728494286818, 46.654080077775085);
const LatLng Passport_Department = LatLng(24.6603442332999, 46.70463920106698);
const LatLng An_Naseem = LatLng(24.701727520269028, 46.82987104286268);
const LatLng Khashm_AlAn = LatLng(24.722596428762152, 46.86107112752105);
const LatLng Sultanah = LatLng(24.61531601628477, 46.68652440053348);
const LatLng AlDar_AlBaidha = LatLng(24.56012323575007, 46.77638578519186);
const LatLng First_Industrial_City =
    LatLng(24.645128413131246, 46.73924760053349);
const AlHilla = LatLng(24.63236794377303, 46.72130899552275);
const Aziziyah = LatLng(24.587767444827744, 46.76085043121673);
const Officers_Club = LatLng(24.698023843619875, 46.7180571582043);
const AlKhaleej = LatLng(24.782133310064207, 46.79386540053349);
const LatLng DK7 = LatLng(24.60102299420869, 46.643912831216724);
const LatLng Southern_Ring_Road = LatLng(24.5988007096572, 46.74559604286267);
const LatLng SAPTCO = LatLng(24.595952176815352, 46.74780618295626);
const LatLng Jarir_District = LatLng(24.675992338837617, 46.760139091132075);
const LatLng Jeddah_Road = LatLng(24.591708184829702, 46.54333827358718);
const LatLng Skirinah = LatLng(24.618221717661566, 46.72486107306263);
const LatLng Manfouhah = LatLng(24.610701124160094, 46.72741364259594);
const LatLng AlMargab = LatLng(24.634223633427975, 46.72564952910215);
const LatLng AlJaradiyah = LatLng(24.62211956062091, 46.697905033439625);
const LatLng King_Fahad_Stadium = LatLng(24.79354574574914, 46.83634875673867);
const LatLng AlNahdha = LatLng(24.757033610827573, 46.790348717811625);
const LatLng AlTakhasusi = LatLng(24.724264557913013, 46.65516659868294);
const LatLng City_Center = LatLng(24.792331161852665, 46.81067411777644);
const LatLng Aisha_bint_Abi_Bakr_Street =
    LatLng(24.600585732347877, 46.6438288400605);
const LatLng Riyadh_Exhibition_Center =
    LatLng(24.754324431106845, 46.726419308444186);
const LatLng Railway = LatLng(24.651181683217757, 46.74060586934959);
const LatLng AlSalihiyah = LatLng(24.6371922661316, 46.7310748022035);
const LatLng KACT = LatLng(24.718496228417234, 46.64255624108287);
const LatLng Courts_Complex = LatLng(24.626383321200905, 46.71147031596318);
const LatLng AlAndalus = LatLng(24.7597732531332, 46.790691465801785);
const LatLng As_Salam = LatLng(24.723618363309235, 46.810809833504834);
const LatLng SABIC = LatLng(24.808213877339156, 46.711586173743825);
const LatLng AlWizarat = LatLng(24.67610434565068, 46.71835829611576);
const LatLng Mew_and_A = LatLng(24.6603043923217, 46.71769858358802);
const LatLng Ministry_Of_Defence = LatLng(24.6676428850683, 46.71837036275971);
const LatLng Abu_Dhabi_Square = LatLng(24.706231, 46.718126);
const LatLng Ad_Dhabab = LatLng(24.70975189111837, 46.70861809542127);
const LatLng GOSI = LatLng(24.6865786216132, 46.718205888877705);
const LatLng Ministry_Of_Finance = LatLng(24.65372808690647, 46.71666113915717);
const LatLng AlSulimaniyah = LatLng(24.711752875638634, 46.70299012147462);
const LatLng Salahaddin = LatLng(24.7286941806714, 46.70017119397027);

class ViewMap extends StatefulWidget {
  const ViewMap({Key? key}) : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMap();
}

class _ViewMap extends State<ViewMap> {
  // ignore: unused_field
  late GoogleMapController _mapController;
  // ignore: prefer_final_fields
  Map<String, Marker> _marker = {};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (user.email != null) {
            await AuthController().signOut();
          } else {
            await AuthController().signOut();
            Get.to(const SignUpScreen());
          }
        },
        backgroundColor: blueColor,
        child: const Icon(Icons.logout_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.71619956670347, 46.68385748947401),
          zoom: 11,
        ),
        onMapCreated: (controller) async {
          String style = await DefaultAssetBundle.of(context)
              .loadString('assets/mapstyle.json');
          //customize your map style at: https://mapstyle.withgoogle.com/
          controller.setMapStyle(style);

          _mapController = controller;

          addMarker('Khurais Road', Khurais_Road);
          addMarker('Al Hamra', Al_Hamra);
          addMarker('King Saud University', King_Saud_University);
          addMarker('MOE', MOE);
          //addMarker('STC', STC);
          addMarker('Ar Rabi', Ar_Rabi);
          addMarker('King Abdullah Financial District',
              King_Abdullah_Financial_District);
          addMarker('AlYarmuk', AlYarmuk);
          addMarker('Qasr AlHukm', Qasr_AlHukm);
          addMarker('STC', STC);
          addMarker('An Nuzhah', An_Nuzhah);
          addMarker('Ad Douh', Ad_Douh);
          addMarker('DK', DK);
          addMarker('DK2', DK2);
          addMarker('AlRajih Grand Mosque', AlRajih_Grand_Mosque);
          addMarker('Uthman bin Affan Road', Uthman_bin_Affan_Road);
          addMarker('King Salman Oasis', King_Salman_Oasis);
          addMarker('Tuwaiq', Tuwaiq);
          addMarker('Granada', Granada);
          addMarker('King_Abdulaziz_Road', King_Abdulaziz_Road);
          addMarker('Harun_AlRasheed', Harun_AlRasheed);
          addMarker('King_Abdullah_Road', King_Abdullah_Road);
          addMarker('AlImam_Hospital', AlImam_Hospital);
          addMarker('King_Khalid_Airport_Terminal_1_2',
              King_Khalid_Airport_Terminal_1_2);
          addMarker('King_Khalid_Airport_Terminal_3_4',
              King_Khalid_Airport_Terminal_3_4);
          addMarker('Hassan_Ibn_Tahit_Street', Hassan_Ibn_Tahit_Street);
          addMarker('West_Station', West_Station);
          addMarker('AlSahafah', AlSahafah);
          addMarker('Khalid Ibn AlWaleed Road', Khalid_Ibn_AlWaleed_Road);
          addMarker('National_Museum', National_Museum);
          // addMarker('DK4', DK4);
          addMarker('Passport_Department', Passport_Department);
          addMarker('AlNaseem', An_Naseem);
          addMarker('Khashm AlAn', Khashm_AlAn);
          addMarker('Sultanah', Sultanah);
          addMarker('AlDar_AlBaidha', AlDar_AlBaidha);
          addMarker('First Industrial City', First_Industrial_City);
          addMarker('AlSulimaniyah', AlSulimaniyah);
          addMarker('AlHilla', AlHilla);
          addMarker('Aziziyah', Aziziyah);
          addMarker('Officers_Club', Officers_Club);
          addMarker('AlKhaleej', AlKhaleej);
          addMarker('SAPTCO', SAPTCO);
          addMarker('Southern_Ring_Road', Southern_Ring_Road);
          addMarker('Jarir District', Jarir_District);
          addMarker('Jeddah Road', Jeddah_Road);
          addMarker('Skirinah', Skirinah);
          addMarker('Manfouhah', Manfouhah);
          addMarker('AlMargab', AlMargab);
          addMarker('AlJaradiyah', AlJaradiyah);
          addMarker('King Fahad Stadium', King_Fahad_Stadium);
          addMarker('AlNahdha', AlNahdha); //53
          addMarker('AlTakhasusi', AlTakhasusi);
          addMarker('City Center Ishniliyah', City_Center);
          addMarker('AlWurud', AlWurud);
          addMarker('Dhahrat AlBadiah', Dhahrat_AlBadiah);
          addMarker('Aisha bint Abi Bakr Street', Aisha_bint_Abi_Bakr_Street);
          addMarker('Riyadh Exhibition Center', Riyadh_Exhibition_Center);
          addMarker('Railway', Railway);
          addMarker('AlSalihiyah', AlSalihiyah);
          addMarker('KACT', KACT);
          addMarker('Courts Complex', Courts_Complex);
          addMarker('AlAndalus', AlAndalus);
          addMarker('As Salam', As_Salam);
          addMarker('SABIC', SABIC);
          addMarker('Abu Dhabi Square', Abu_Dhabi_Square);
          addMarker('Ad_Dhabab', Ad_Dhabab);
          addMarker('GOSI', GOSI);
          addMarker('AlWizarat', AlWizarat);
          addMarker('MEW & A', Mew_and_A); //5A2
          addMarker('Ministry Of Defence', Ministry_Of_Defence); //defence
          addMarker('Ministry Of Finance', Ministry_Of_Finance);
          addMarker('Salahaddin', Salahaddin);
        },
        polylines: _polyline,
        markers: _marker.values.toSet(),
      ),
    );
  }

  final Set<Polyline> _polyline = {};

//red line
  List<LatLng> red_line = [
    King_Fahad_Stadium,
    City_Center,
    AlKhaleej,
    Al_Hamra,
    Khalid_Ibn_AlWaleed_Road,
    Riyadh_Exhibition_Center,
    An_Nuzhah,
    MOE,
    King_Abdulaziz_Road,
    AlWurud,
    STC,
    AlTakhasusi,
    KACT,
    King_Salman_Oasis,
    King_Saud_University,
  ];

  //orange line
  List<LatLng> orange_line = [
    Khashm_AlAn,
    Hassan_Ibn_Tahit_Street,
    An_Naseem,
    Harun_AlRasheed,
    AlRajih_Grand_Mosque,
    Jarir_District,
    Railway,
    First_Industrial_City,
    AlSalihiyah,
    AlMargab,
    AlHilla,
    Qasr_AlHukm,
    Courts_Complex,
    AlJaradiyah,
    Sultanah,
    Dhahrat_AlBadiah,
    West_Station,
    Ad_Douh,
    Tuwaiq,
    Jeddah_Road
  ];

  List<LatLng> purple_line = [
    King_Abdullah_Financial_District,
    Ar_Rabi,
    Uthman_bin_Affan_Road,
    SABIC,
    Granada,
    AlYarmuk,
    Al_Hamra,
    AlAndalus,
    Khurais_Road,
    As_Salam,
    An_Naseem,
  ];

  List<LatLng> green_line = [
    MOE,
    Salahaddin,
    AlSulimaniyah,
    Ad_Dhabab,
    Abu_Dhabi_Square,
    Officers_Club,
    GOSI,
    AlWizarat,
    Ministry_Of_Defence,
    Mew_and_A,
    Ministry_Of_Finance,
    National_Museum,
  ];

  addMarker(String id, LatLng location) async {
    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/metroIcon.png',
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: id,
        //snippet: id,
      ),
      icon: markerIcon,
    );

    _polyline.add(
      Polyline(
          polylineId: PolylineId('1'), points: red_line, color: Colors.red),
    );

    _polyline.add(Polyline(
        polylineId: PolylineId('2'),
        points: orange_line,
        color: Colors.orange));

    _polyline.add(Polyline(
        polylineId: PolylineId('3'),
        points: purple_line,
        color: Colors.purple));

    _polyline.add(Polyline(
        polylineId: PolylineId('4'), points: green_line, color: Colors.green));

    _marker[id] = marker;
    setState(() {});
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sekkah_app/Homepage/map_controller.dart';
// //import 'package:firebase_auth/firebase_auth.dart';
// //import 'package:get/get.dart';
// //import 'package:sekkah_app/Register/signup_screen.dart';
// //import 'package:sekkah_app/others/auth_controller.dart';
// //import 'package:sekkah_app/others/constants.dart';
// // ignore: unused_import
// import 'package:sekkah_app/Homepage/navigation.dart';
// import 'package:sekkah_app/helpers/stations_model.dart';
// import 'package:sekkah_app/others/auth_controller.dart';
// //import '../helpers/map_locations.dart';

// class ViewMap extends StatefulWidget {
//   const ViewMap({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ViewMap createState() => _ViewMap();
// }

// class _ViewMap extends State<ViewMap> {
//   // ignore: unused_field
//   late GoogleMapController _mapController;
//   // MapStationsController mapController = Get.put(MapStationsController());
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetX<MapStationsController>(
//         init: MapStationsController(),
//         builder: (controller) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Map'),
//               backgroundColor: Colors.blue,
//               actions: [
//                 TextButton(
//                     onPressed: () => AuthController().signOut(),
//                     child: Text(
//                       "Signout",
//                       style: TextStyle(color: Colors.white),
//                     ))
//               ],
//             ),
//             body: GoogleMap(
//                 markers: Set<Marker>.of(controller.markers.values),
//                 initialCameraPosition: const CameraPosition(
//                   target: LatLng(24.71619956670347, 46.68385748947401),
//                   zoom: 11,
//                 ),
//                 onMapCreated: (GoogleMapController controller) async {
//                   String style = await DefaultAssetBundle.of(context)
//                       .loadString('assets/mapstyle.json');
//                   //customize your map style at: https://mapstyle.withgoogle.com/
//                   controller.setMapStyle(style);
//                   _mapController = controller;
//                 }),
//           );
//           // return SafeArea(
//           //   child: Scaffold(
//           //     body: Column(
//           //       children: [
//           //         // TextButton(
//           //         //     onPressed: () => controller.init(),
//           //         //     child: Text("fetch values")),
//           //         // Expanded(
//           //         //   child: ListView.builder(
//           //         //       shrinkWrap: true,
//           //         //       itemCount: controller.allStations.length,
//           //         //       itemBuilder: (context, index) {
//           //         //         return Text(
//           //         //           controller.allStations[index].Name,
//           //         //           style: TextStyle(color: Colors.black),
//           //         //         );
//           //         //       }),
//           //         // ),
//           //       ],
//           //     ),
//           //     // body: ,
//           //   ),
//           // );
//         });
//   }
// }

