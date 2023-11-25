import 'package:flutter/material.dart';

import '../utiles/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController txtController;
  final Function(String)? onSubmitted;
  final bool passView;

  const TextFieldWidget(
      {Key? key, required this.txtController, required this.passView, this.onSubmitted,})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted:onSubmitted,
      controller: txtController,
      obscureText: passView,
      decoration: InputDecoration(
        filled: true,
        isDense: false,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: buttonColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          // Kenarlık rengini ayarlayabilirsiniz.
          borderRadius:
          BorderRadius.circular(10), // Köşeleri yuvarlamak için
        ),
      ),
    );
  }
}
