import 'package:flutter/material.dart';

class CustomMessageScreen {

  static void showMessage(BuildContext context, String message, Color color, IconData icon) {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });

        return  AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Row(
            children: <Widget>[
              Icon(icon,color: color,),
              const SizedBox(width: 10),
              Text(message,style: TextStyle(color: color),),
            ],
          ),
        );
      },
    );
  }
}
