// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:sekkah_app/data/constants.dart';
import 'package:sekkah_app/data/typography.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final bool showCalenderIcon;
  final VoidCallback oncross;
  final Function(String) onChanged;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    required this.showCalenderIcon,
    required this.oncross,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

bool obsecureText = false;

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      style: TextStyle(
          fontSize: 14,
          fontWeight: CustomFontWeight.kRegularWeight,
          color: CustomColor.ksemigrey),
      readOnly: widget.showCalenderIcon,
      decoration: InputDecoration(
        suffixIcon: widget.showCalenderIcon
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: () async {
                    Future<DateTime?> pickDate() => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                          builder: (context, child) {
                            return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: CustomColor.kprimaryblue,
                                    onPrimary: Colors.white,
                                    surface: CustomColor.kbackgroundwhite,
                                    onSurface: CustomColor.kprimaryblue,
                                  ),
                                  dialogBackgroundColor:
                                      CustomColor.kbackgroundwhite,
                                ),
                                child: child!);
                          },
                        );
                    Future<TimeOfDay?> pickTime() => showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: CustomColor.kprimaryblue,
                                    onPrimary: Colors.white,
                                    surface: CustomColor.kbackgroundwhite,
                                    onSurface: CustomColor.kprimaryblue,
                                  ),
                                  dialogBackgroundColor:
                                      CustomColor.kbackgroundwhite,
                                ),
                                child: child!);
                          },
                        );
                    DateTime? date = await pickDate();
                    if (date == null) return;

                    TimeOfDay? time = await pickTime();
                    if (time == null) return;
                    final datetime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );

                    setState(() {
                      widget.controller.text =
                          DateFormat('dd-MMM-yyyy h:mm a').format(datetime).toString();
                    });
                  },
                  child: Icon(Icons.calendar_today_sharp,
                      color: CustomColor.ksemigrey, size: 18),
                ),
              )
            : InkWell(
                onTap: widget.oncross,
                child:
                    Icon(Icons.close, color: CustomColor.ksemigrey, size: 18)),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: CustomFontWeight.kRegularWeight,
            color: CustomColor.ksemigrey),
        fillColor: CustomColor.klightgrey,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8)),
      ),
      cursorColor: CustomColor.ksemigrey,
    );
  }
}