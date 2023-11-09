import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/screen/broadcast_screen.dart';
import 'package:twitch_clone/utiles/colors.dart';
import 'package:twitch_clone/utiles/utiles.dart';
import 'package:twitch_clone/widgets/button_widget.dart';

import '../widgets/textfield_widget.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({Key? key}) : super(key: key);

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    String chanalId = await FireStoreMethods()
        .startLiveStream(context, titleController.text, image);
    print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    if (chanalId.isNotEmpty) {
      showSnackBar(context, 'LiveStream has started sucsessfuly', Colors.green);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: BroadScreen(),
        ),
      );
    }
  }

  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / 15, vertical: size.height / 50),
                child: GestureDetector(
                  onTap: () async {
                    Uint8List? pickerImage = await pickImager();
                    if (pickerImage != null) {
                      setState(() {
                        image = pickerImage;
                      });
                    }
                  },
                  child: image == null
                      ? SizedBox(
                          width: size.width,
                          height: size.height / 5,
                          child: DottedBorder(
                            dashPattern: const [10, 4],
                            strokeWidth: 2,
                            borderType: BorderType.RRect,
                            color: buttonColor,
                            radius: Radius.circular(size.width / 25),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(size.width / 25)),
                                child: Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: buttonColor.withOpacity(0.1)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_outlined,
                                        size: size.width / 8,
                                        color: buttonColor,
                                      ),
                                      Text(
                                        'Select your thumbnail',
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w400,
                                            fontSize: size.width / 30),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        )
                      : SizedBox(
                          width: size.width,
                          height: size.height / 5,
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(size.width / 10),
                              ),
                            ),
                            child: Image.memory(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width / 25, vertical: size.height / 60),
                child: Text(
                  'Title',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: size.width / 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width / 25,
                  right: size.width / 25,
                ),
                child: TextFieldWidget(
                  passView: false,
                  txtController: titleController,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: InkWell(
            onTap: goLiveStream,
            child: const ButtonWidget(
              backGColor: buttonColor,
              txt: 'Go Live!',
              buttonTextColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
