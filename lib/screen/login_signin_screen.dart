import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitch_clone/resources/auth_methods.dart';
import 'package:twitch_clone/screen/home_screen.dart';
import 'package:twitch_clone/utiles/colors.dart';
import 'package:twitch_clone/utiles/utiles.dart';
import 'package:twitch_clone/widgets/button_widget.dart';
import 'package:twitch_clone/widgets/textfield_widget.dart';

class LoginSigninScreen extends StatefulWidget {
  final bool control;

  const LoginSigninScreen({Key? key, required this.control}) : super(key: key);

  @override
  State<LoginSigninScreen> createState() => _LoginSigninScreenState();
}

class _LoginSigninScreenState extends State<LoginSigninScreen> {
  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPassController = TextEditingController();

  TextEditingController signinEmailController = TextEditingController();
  TextEditingController signinUsernameController = TextEditingController();
  TextEditingController signinPassController = TextEditingController();

  late bool value;

  @override
  void initState() {
    value = widget.control;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return value
        ? Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Log in',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 6,
            ),
            textAndTextField(
                size, 'Username', loginUsernameController, false),
            textAndTextField(size, 'Password', loginPassController, true),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width / 25,
                  top: size.height / 25,
                  right: size.width / 25),
              child: InkWell(
                onTap: () async {
                  bool res=await AuthMethods().loginUser(
                      loginUsernameController.text, loginPassController.text);
                  if(res){
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: HomeScreen(),
                      ),
                    );
                  }
                },
                child: const ButtonWidget(
                  backGColor: buttonColor,
                  txt: 'Log in',
                  buttonTextColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: size.width / 25,
                top: size.height / 50,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    value = false;
                  });
                },
                child: accountText(
                  size,
                  'I Don\'t have any an account!',
                ),
              ),
            )
          ],
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign in'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 8,
            ),
            textAndTextField(size, 'Email', signinEmailController, false),
            textAndTextField(
                size, 'Username', signinUsernameController, false),
            textAndTextField(
                size, 'Password', signinPassController, true),
            Padding(
              padding: EdgeInsets.only(
                left: size.width / 25,
                right: size.width / 25,
                top: size.height / 25,
              ),
              child: InkWell(
                onTap: () async {
                  bool control = await AuthMethods().signupUser(
                    signinEmailController.text,
                    signinUsernameController.text,
                    signinPassController.text,
                    context
                  );
                  if (control) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: HomeScreen(),
                      ),
                    );
                  }
                },
                child: const ButtonWidget(
                    backGColor: buttonColor,
                    txt: 'Sign in',
                    buttonTextColor: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width / 25, top: size.height / 50),
              child: InkWell(
                  onTap: () {
                    setState(
                          () {
                        value = true;
                      },
                    );
                  },
                  child: accountText(size, 'I have an account!')),
            )
          ],
        ),
      ),
    );
  }

  Text accountText(Size size, String txt) {
    return Text(
      txt,
      style: TextStyle(
        color: const Color(0xff407edc),
        decoration: TextDecoration.underline,
        fontSize: size.width / 22,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Column textAndTextField(Size size, String txt,
      TextEditingController txtController, bool passView) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: size.width / 25,
          ),
          child: Text(
            txt,
            style: TextStyle(
              color: primaryColor,
              fontSize: size.width / 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width / 25,
            vertical: size.height / 80,
          ),
          child: TextFieldWidget(
            passView: passView,
            txtController: txtController,
          ),
        ),
      ],
    );
  }
}
