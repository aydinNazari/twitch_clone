
import 'package:flutter/material.dart';

showSnackBar(BuildContext context,String txt,Color color){
  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content:Text(
        txt,
      ),
      backgroundColor:color,
      duration:const Duration(seconds:1),
    ),
  );
}