import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/models/livestream.dart';
import 'package:twitch_clone/providers/user_provider.dart';
import 'package:twitch_clone/resources/storage_methods.dart';

import '../utiles/utiles.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods _storagMethods = StorageMethods();

  //final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> startLiveStream(
      BuildContext context, String title, Uint8List? image) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String chanalId = '';
    try {
      if (title.isNotEmpty && image != null) {
        if (!((await _firestore
                .collection('livestream')
                .doc(user.user.uid + user.user.username)
                .get())
            .exists)) {
          print(user.user.uid);
          String thumbnailUrl = await _storagMethods.uploadImageToStorage(
              'livestream-thumbnails', image, user.user.uid);
          print(3333333333);

          chanalId = user.user.uid + user.user.username;
          LiveStream liveStream = LiveStream(
            title: title,
            uid: user.user.uid,
            image: thumbnailUrl,
            username: user.user.username,
            chanalId: chanalId,
            startedAt: DateTime.now(),
            viewers: 0,
          );

          _firestore
              .collection('livestream')
              .doc(chanalId)
              .set(liveStream.toMap());
        } else {
          showSnackBar(context, 'Tow livestream can not start', Colors.red);
        }
      } else {
        showSnackBar(context, 'Please enter all the fields', Colors.red);
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!, Colors.red);
    }
    return chanalId;
  }

  Future<void> endLiveStream(String channalId) async {
    print('girdiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    try {
      QuerySnapshot snap = await _firestore
          .collection('livestream')
          .doc(channalId)
          .collection('comments')
          .get();
      for (int i = 0; i < snap.docs.length; i++) {
        _firestore
            .collection('livestream')
            .doc(channalId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      print(
          '777777777777777777777777777777777777777777777777777777777777777777');
     /* var aa = (await _firestore
          .collection('livestream')
          .doc(channalId)
          .get());*/
      print(channalId);
      await _firestore.collection('livestream').doc(channalId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore.collection('livestream').doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
