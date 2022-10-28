import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sekkah_app/Register/signup_screen.dart';
import 'package:sekkah_app/others/auth_controller.dart';
import 'package:sekkah_app/others/constants.dart';
import 'package:sekkah_app/Homepage/navigation.dart';
import '../helpers/map_locations.dart';

const LatLng Khurais_Road = LatLng(24.740946376833584, 46.798506629342775);
const LatLng Al_Hamra = LatLng(24.776695973800166, 46.777197831194556);
const LatLng King_Saud_University =
    LatLng(24.713218882457202, 46.62857961831653);
const LatLng MOE = LatLng(24.740716559819983, 46.694773729870136);
//const LatLng STC = LatLng(24.72665826728583, 46.66700133999424);
const LatLng Ar_Rabi = LatLng(24.78629195996191, 46.66013792585841);
const LatLng King_Abdullah_Financial_District =
    LatLng(24.767467334723097, 46.64305311230236);
const LatLng Yarmuk = LatLng(24.791197738712103, 46.76626014236253);
const LatLng Qasr_AlHukm = LatLng(24.62898633421732, 46.71614447119793);
const LatLng AlWurud = LatLng(24.728513713582622, 46.66647663657381);
const LatLng STC = LatLng(24.72780279168026, 46.66402971583957);
const LatLng An_Nuzhah = LatLng(24.748232849680114, 46.712524046659894);
const LatLng Ad_Douh = LatLng(24.582687500762187, 46.58829571230235);
const LatLng DK = LatLng(24.724035388519273, 46.655157716642734);
const LatLng DK2 = LatLng(24.722173718445912, 46.861130749011366);
const LatLng AlRajhi_Grand_Mosque =
    LatLng(24.680257767875453, 46.779516666456296);
const LatLng Othman_Bin_Affan = LatLng(24.801506858888473, 46.69584175608972);
const LatLng King_Salman_Oasis = LatLng(24.717206999063556, 46.638721784925124);
const LatLng Tuwaiq = LatLng(24.585613556916503, 46.559645359137875);
const LatLng Garanada_Mall = LatLng(24.786596609860684, 46.72914975780418);
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
const LatLng DK4 = LatLng(24.60728494286818, 46.654080077775085);
const LatLng Passport_Department = LatLng(24.6603442332999, 46.70463920106698);
const LatLng AlNaseem = LatLng(24.701727520269028, 46.82987104286268);
const LatLng DK5 = LatLng(24.722596428762152, 46.86107112752105);
const LatLng Sultanah = LatLng(24.61531601628477, 46.68652440053348);
const LatLng AlDar_AlBaidha = LatLng(24.56012323575007, 46.77638578519186);
const LatLng First_Industrial_City =
    LatLng(24.645128413131246, 46.73924760053349);
const LatLng DK6 = LatLng(24.710032819169204, 46.708629158204296);
const AlHilla = LatLng(24.63236794377303, 46.72130899552275);
const Aziziyah = LatLng(24.587767444827744, 46.76085043121673);
const Officers_Club = LatLng(24.698023843619875, 46.7180571582043);
const AlKhaleej = LatLng(24.782133310064207, 46.79386540053349);
const LatLng DK7 = LatLng(24.60102299420869, 46.643912831216724);
const LatLng Southern_Ring_Road = LatLng(24.5988007096572, 46.74559604286267);
const LatLng SAPTCO = LatLng(24.595952176815352, 46.74780618295626);
const LatLng Jarir = LatLng(24.675992338837617, 46.760139091132075);
const LatLng DK8 = LatLng(24.591708184829702, 46.54333827358718);
const LatLng Skirinah = LatLng(24.618221717661566, 46.72486107306263);
const LatLng Manfouhah = LatLng(24.610701124160094, 46.72741364259594);
const LatLng AlMargab = LatLng(24.634223633427975, 46.72564952910215);
const LatLng AlJaradiyah = LatLng(24.62211956062091, 46.697905033439625);
const LatLng King_Fahad_Stadium = LatLng(24.793133797228098, 46.81058598096131);
const LatLng AlNahdha = LatLng(24.757033610827573, 46.790348717811625);
const LatLng AlTakhasusi = LatLng(24.724264557913013, 46.65516659868294);
const LatLng City_Center = LatLng(24.792331161852665, 46.81067411777644);

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
          addMarker('Yarmuk', Yarmuk);
          addMarker('Qasr AlHukm', Qasr_AlHukm);
          addMarker('STC', STC);
          addMarker('An Nuzhah', An_Nuzhah);
          addMarker('Ad Douh', Ad_Douh);
          addMarker('DK', DK);
          addMarker('DK2', DK2);
          addMarker('AlRajhi_Grand_Mosque', AlRajhi_Grand_Mosque);
          addMarker('Othman Bin Affan', Othman_Bin_Affan);
          addMarker('King Salman Oasis', King_Salman_Oasis);
          addMarker('Tuwaiq', Tuwaiq);
          addMarker('Garanada_Mall', Garanada_Mall);
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
          addMarker('DK4', DK4);
          addMarker('Passport_Department', Passport_Department);
          addMarker('AlNaseem', AlNaseem);
          addMarker('DK5', DK5);
          addMarker('Sultanah', Sultanah);
          addMarker('AlDar_AlBaidha', AlDar_AlBaidha);
          addMarker('First_Industrial_City', First_Industrial_City);
          addMarker('DK6', DK6);
          addMarker('AlHilla', AlHilla);
          addMarker('Aziziyah', Aziziyah);
          addMarker('Officers_Club', Officers_Club);
          addMarker('AlKhaleej', AlKhaleej);
          addMarker('SAPTCO', SAPTCO);
          addMarker('Southern_Ring_Road', Southern_Ring_Road);
          addMarker('Jarir', Jarir);
          addMarker('DK8', DK8);
          addMarker('Skirinah', Skirinah);
          addMarker('Manfouhah', Manfouhah);
          addMarker('AlMargab', AlMargab);
          addMarker('AlJaradiyah', AlJaradiyah);
          addMarker('King Fahad Stadium', King_Fahad_Stadium);
          addMarker('AlNahdha', AlNahdha); //53
          addMarker('AlTakhasusi', AlTakhasusi);
          addMarker('City Center Ishniliyah', City_Center);
          addMarker('AlWurud', AlWurud);
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
    An_Nuzhah,
    MOE,
    King_Abdulaziz_Road,
    AlWurud,
    STC,
    AlTakhasusi,
    King_Salman_Oasis,
    King_Saud_University,
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

    _marker[id] = marker;
    setState(() {});
  }
}
