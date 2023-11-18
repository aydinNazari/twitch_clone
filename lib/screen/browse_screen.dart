import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitch_clone/resources/auth_methods.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/screen/login_signin_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            AuthMethods().signOut();
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const LoginSigninScreen(
                  control: false,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.logout,
          ),
        ),
      ),
    );
  }
}
