import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twitch_clone/screen/browse_screen.dart';
import 'package:twitch_clone/screen/feed_screen.dart';
import 'package:twitch_clone/screen/go_live_screen.dart';

showSnackBar(BuildContext context, String txt, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        txt,
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 1),
    ),
  );
}

List<Widget> navigatorListScreen = const [
  FeedScreen(),
  GoLiveScreen(),
  BrowseScreen()
];

Future<Uint8List?>pickImager() async {
  FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if(kIsWeb){
    return pickedImage?.files.single.bytes;
  }
  if(pickedImage!=null){
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}
