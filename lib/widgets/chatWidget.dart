import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/providers/user_provider.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/widgets/textfield_widget.dart';

import '../utiles/utiles.dart';

class ChatWidget extends StatefulWidget {
  final String chanalId;

  const ChatWidget({Key? key, required this.chanalId}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

final TextEditingController texEditController = TextEditingController();

class _ChatWidgetState extends State<ChatWidget> {
  @override
  void dispose() {
    texEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return SizedBox(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: firebaseFirestore
                  .collection('livestream')
                  .doc(widget.chanalId)
                  .collection('comments')
                  .orderBy('creatAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      snapshot.data.docs[index]['username'],
                      style: TextStyle(
                          color: snapshot.data.docs[index]['uid'] ==
                                  userProvider.user.uid
                              ? Colors.blue
                              : Colors.black),
                    ),
                    subtitle: Text(snapshot.data.docs[index]['message']),
                  ),
                );
              },
            ),
          ),
          TextFieldWidget(
            txtController: texEditController,
            passView: false,
            onSubmitted: (value) {
              FireStoreMethods().chat(value,widget.chanalId,context);
              setState(() {
                texEditController.text='';
              });
            },
          )
        ],
      ),
    );
  }
}
