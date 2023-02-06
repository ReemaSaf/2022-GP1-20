import 'package:flutter/material.dart';

dp({msg, arg}) => debugPrint("\n $msg =$arg \n ");

showSnackBarMessage({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.black,
        ),
        overflow: TextOverflow.visible,
      )));
}
