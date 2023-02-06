import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WrapContainer extends StatelessWidget {
  final Widget child;
  const WrapContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffFAFAFA).withOpacity(0.98),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.r),
            topLeft: Radius.circular(40.r),
          ),
        ),
        child:  child);
  }
}
