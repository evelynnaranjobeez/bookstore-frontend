import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/controller.dart';
import '../repository/user_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState(Controller());
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  Controller? _con;
  double opacity = 0;

  SplashScreenState(Controller controller) : super(controller) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    showAfter(context);
  }

  Future<void> showAfter(context) async {
    await Future.delayed(Duration(seconds: 1), () {});
    setState(() {
      opacity = 1;
      onDoneLoading();
    });
  }

  onDoneLoading() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      if (currentUser.apiToken == null) {
        Navigator.of(context).pushReplacementNamed('/Login');
      } else {
        Navigator.of(context).pushReplacementNamed('/Homepage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con!.scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    width: 200,
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        Image.asset("assets/img/books.png"),
                        Positioned(
                            bottom: 10,
                            left: 11,
                            child: Text(
                              "Book Store",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .merge(TextStyle(
                                      letterSpacing: 2,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600)),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          children: <Widget>[
                            const Text("Made by",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey)),
                            Text('Evelyn Naranjo',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
