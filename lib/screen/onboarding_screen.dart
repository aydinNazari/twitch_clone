import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitch_clone/screen/login_signin_screen.dart';
import 'package:twitch_clone/screen/signup_screen.dart';
import 'package:twitch_clone/utiles/colors.dart';
import 'package:twitch_clone/widgets/button_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: size.width / 15,
            ),
            child: Text(
              'Welcom\nto Twitch',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: size.width / 12,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: size.width / 25,
              right: size.width / 25,
              top: size.height / 20,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: LoginSigninScreen(control: true),
                      ),
                    );
                  },
                  child: const ButtonWidget(
                    txt: 'Log In',
                    backGColor: buttonColor,
                    buttonTextColor: secendaryBackGroundColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height / 50),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child:  LoginSigninScreen(control: false,),
                        ),
                      );
                    },
                    child: const ButtonWidget(
                      txt: 'Sign Up',
                      backGColor: secendaryBackGroundColor,
                      buttonTextColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
