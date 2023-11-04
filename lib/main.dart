import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/providers/user_provider.dart';
import 'package:twitch_clone/screen/onboarding_screen.dart';
import 'package:twitch_clone/utiles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitch Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme.of(context).copyWith(
              elevation: 0,
              backgroundColor: backgroundColor,
              titleTextStyle: TextStyle(
                color: primaryColor,
                fontSize: MediaQuery.of(context).size.width / 18,
                fontWeight: FontWeight.w700,
              ),
              iconTheme: const IconThemeData(color: primaryColor))),
      home: const OnBoardingScreen(),
    );
  }
}
