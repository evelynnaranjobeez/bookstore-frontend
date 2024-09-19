import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart'
    as repository;
import '../models/user.dart';

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool isLoading = false;
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<ScaffoldState> scaffoldKey;


  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      loginFormKey.currentState!.save();
      repository.login(user).then((value) {
        if (value.apiToken != null) {

          setState(() {
            isLoading = false;
          });
          Navigator.of(scaffoldKey.currentContext!)
              .pushReplacementNamed('/Homepage');
        } else {
          setState(() {
            isLoading = false;
          });
         ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(const SnackBar(
            content: Text('Login failed! Please check your credentials'),
          ));
        }
      });
    }
  }



}
