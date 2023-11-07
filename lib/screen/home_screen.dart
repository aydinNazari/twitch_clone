import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/utiles/colors.dart';

import '../providers/user_provider.dart';
import '../utiles/utiles.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;

  onSelect(int value) {
    index = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final userProvider=Provider.of<UserProvider>(context,listen: false);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        onTap: onSelect,
        unselectedFontSize: size.width / 35,
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.favorite,
              size: size.width / 15,
            ),
            icon: Icon(Icons.favorite_border, size: size.width / 18),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined, size: size.width / 18),
            activeIcon: Icon(Icons.add, size: size.width / 15),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy, size: size.width / 18),
            activeIcon: Icon(
              Icons.copy,
              size: size.width / 15,
            ),
            label: 'Browse',
          )
        ],
      ),
      body: navigatorListScreen[index],
    );
  }
}
