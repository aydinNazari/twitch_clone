import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider=Provider.of<UserProvider>(context,listen: false);
    return Scaffold(
      body: Center(child: Text(userProvider.user.username)),
    );
  }
}
