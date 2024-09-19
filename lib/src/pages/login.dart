import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../config/app_config.dart' as config;

import '../repository/user_repository.dart' as userRepo;

import '../../generated/i18n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';

class LoginWidget extends StatefulWidget {

  @override
  _LoginWidgetState createState() => _LoginWidgetState(UserController());
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController? _con;

  _LoginWidgetState(UserController controller) : super(controller) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    if (userRepo.currentUser.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con!.scaffoldKey,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(37),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(37) - 180,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(37),
                child: Text(
                  "Book Store",
                  style: Theme.of(context).textTheme.headlineMedium!.merge(
                      TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 40)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(37) - 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                width: config.App(context).appWidth(88),
                child: Form(
                  key: _con!.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con!.user.email = input,
                        validator: (input) => !input!.contains('@')
                            ? S.of(context)!.should_be_a_valid_email
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context)!.email,
                          labelStyle: const TextStyle(
                              color: Colors.black),
                          contentPadding: const EdgeInsets.all(12),
                          hintText: 'client@gmail.com',
                          hintStyle: TextStyle(
                            fontSize: 14,
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.alternate_email,
                              color: Theme.of(context).colorScheme.secondary),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _con!.user.password = input,
                        validator: (input) => input!.length < 3
                            ? S.of(context)!.should_be_more_than_3_characters
                            : null,
                        obscureText: _con!.hidePassword,
                        decoration: InputDecoration(
                          labelText: S.of(context)!.password,
                          labelStyle: TextStyle(
                              color: Colors.black),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '••••••••••••',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).colorScheme.secondary),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con!.hidePassword = !_con!.hidePassword;
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(_con!.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: Text(
                          S.of(context)!.login,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor!, fontSize: 16),
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          _con!.login();
                        },
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: config.App(context).appHeight(37) - 100,
                right: -20,
                child: Container(
                  width: config.App(context).appWidth(30),
                  height: config.App(context).appHeight(15),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(90 / 80),
                      child: Image.asset("assets/img/books.png")),
                )),
            _con!.isLoading
                ? Container(
                    color: Colors.white.withOpacity(0.4),
                    height: config.App(context).appHeight(70),
                    width: config.App(context).appWidth(100),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
