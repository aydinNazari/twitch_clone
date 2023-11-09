import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/models/user.dart' as model;
import 'package:twitch_clone/providers/user_provider.dart';
import 'package:twitch_clone/utiles/utiles.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('users');

  Future<model.User> getCurrentUser(String? uid) async {
    DocumentSnapshot cred = await _userRef.doc(uid).get();
    model.User user = model.User(
        uid: uid!,
        email: (cred.data()! as dynamic)['email'],
        username: (cred.data()! as dynamic)['username']);
    return user;
  }

  Future<bool> signupUser(
      String email, String username, String pass, BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (cred.user != null) {
        model.User user = model.User(
          uid: cred.user!.uid,
          email: email.trim(),
          username: username.trim(),
        );
        await _userRef.doc(cred.user!.uid).set(user.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, Colors.red);
    }
    return res;
  }

  Future<bool> loginUser(
      String email, String pass, BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (cred.user != null) {
        //model.User user=model.User(uid: uid, email: email, username: username);
        model.User user = await getCurrentUser(cred.user!.uid);
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return res;
  }
}
