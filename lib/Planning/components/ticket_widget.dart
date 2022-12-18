// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TicketWidget extends StatefulWidget {
  const TicketWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.isCornerRounded = false,
    this.shadow,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadow;

  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        // ignore: sort_child_properties_last
        child: widget.child,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          boxShadow: widget.shadow,
          color: widget.color,
          // borderRadius: widget.isCornerRounded
          //     ? BorderRadius.circular(20.0)
          //     : BorderRadius.circular(0.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
      Rect.fromCircle(
        center: Offset(0.0, size.height / 2),
        radius: 10.0,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2),
        radius: 10.0,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}