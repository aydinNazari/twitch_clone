import 'package:flutter/material.dart';

import '../utiles/colors.dart';

class ButtonWidget extends StatelessWidget {
  final Color backGColor;
  final Color buttonTextColor;
  final String txt;

  const ButtonWidget({
    Key? key,
    required this.backGColor,
    required this.txt, required this.buttonTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height / 15,
      decoration: BoxDecoration(
        color: backGColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            size.width / 50,
          ),
        ),
      ),
      child: Center(
          child: Text(
        txt,
        style: TextStyle(
          fontSize: size.width / 25,
          color: buttonTextColor,
        ),
      )),
    );
  }
}
