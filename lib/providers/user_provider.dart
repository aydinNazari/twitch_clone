import 'package:flutter/material.dart';
import 'package:twitch_clone/models/user.dart';

class UserProvider extends ChangeNotifier{
  User _user=User(uid: '', email: '', username: '');
  User get user =>_user;
  setUser(User user){
    _user=user;
    notifyListeners();
  }
}