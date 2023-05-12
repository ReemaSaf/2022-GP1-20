// ignore_for_file: prefer_const_literals_to_create_immutables, file_names, unused_import, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';
import '../helpers/user_model.dart';
import 'HistoryWidget.dart';

class HistoryTickets extends StatefulWidget {
  const HistoryTickets({Key? key}) : super(key: key);
  @override
  State<HistoryTickets> createState() => _HistoryTickets();
}

class _HistoryTickets extends State<HistoryTickets> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Center(
                child: Text(
                  'Tickets History',
                  style: poppinsMedium.copyWith(
                    fontSize: 18.0,
                    color: AppColors.blueDarkColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  width: width(context),
                  padding:
                      EdgeInsets.symmetric(horizontal: height(context) * 0.02),
                  decoration: const BoxDecoration(
                      color: AppColors.blueDarkColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: auth.currentUser == null ||
                          auth.currentUser!.isAnonymous
                      ? const Center(
                          child: Center(
                            child: Text(
                              '',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                          ),
                        )
                      : StreamBuilder<UserModel>(
                          stream: _firestore
                              .collection(
                                  'Passenger') //from passengers collection
                              .doc(auth.currentUser!.uid)
                              .snapshots()
                              .map((event) => UserModel.fromMap(event.data() as Map<
                                  String,
                                  dynamic>)), //Converting data from stream to Usermodel
                          builder: (context, snapshot) {
                            //Check State, If is Waiting  show Circular Indicator
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            // if (snapshot.data == null) {
                            //   return const Center(
                            //     child: Text(
                            //       'Login first....',
                            //       style: TextStyle(
                            //           fontSize: 19, color: Colors.white),
                            //     ),
                            //   );
                            // }
                            UserModel? user = snapshot.data!;
                            return StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('tickets')
                                  .where('user',
                                      isEqualTo: auth.currentUser!.uid)
                                  .orderBy('time', descending: true)
                                  .snapshots(), // Eg a firebase query
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return  Center(
                                    child: Center(
                                      child: Text(
                                        '',
                                        style: poppinsMedium.copyWith(
                                          fontSize: 14.0,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.data!.docs.isEmpty) {
                                  return Center(
                                    child: Center(
                                      child: Text(
                                        'Begin your journey and book your first trip!',
                                        style: poppinsMedium.copyWith(
                                          fontSize: 14.0,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Center(
                                      child: Text(
                                        'Something went wrong',
                                        style: TextStyle(
                                            color: AppColors.whiteColor),
                                      ),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                    // vertical: 5
                                  ),
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.size,
                                      itemBuilder: (context, int index) {
                                        return TripDurationBox(
                                          start: snapshot.data!.docs[index]
                                              ['startLocation'],
                                          end: snapshot.data!.docs[index]
                                              ['endLocation'],
                                          date: snapshot
                                              .data!.docs[index]['time']
                                              .toDate(),
                                          tickets: snapshot.data!.docs[index]
                                              ['tickets'],
                                          username: user.firstName +
                                              " " +
                                              user.lastName,
                                        );
                                      }),
                                );
                              },
                            );
                          })),
            )
          ],
        ),
      ),
    );
  }
}
