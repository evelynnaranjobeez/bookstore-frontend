import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as userRepo;

class Controller extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  Controller() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
   var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.white,
    Colors.yellow,
    Colors.purple
  ];
    var colorizeTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
    fontFamily: 'Horizon',
  );

  @override
  void initState() {
    userRepo.getCurrentUser().then((user) {
      setState(() {
        userRepo.currentUser = user!;
      });
    });
  }
}
