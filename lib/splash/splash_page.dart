 import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
var devicetoken;
class SplashPage extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
   // removeStringToSF();
    _firebaseMessaging.getToken().then((token)
    async {

      prefs = await SharedPreferences.getInstance();
      setState(()
      {
        devicetoken=token;
        prefs.setString('devicetoken',devicetoken);
        print('Token>>>>$devicetoken');

      });
    });
    Timer(Duration(seconds: 3), () => _isLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 320,
          height: 280,
        ),
      ),
    );
  }

  /* _isLogin() async {

    */ /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PdfViewPage(path: urlPDFPath)));*/ /*

    var preferences = await SharedPreferences.getInstance();
    preferences.getBool(Preferences.isLoggedInKey) == null ? Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new LoginPage())) : Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new UserSelectionPage()));
  }*/

  _isLogin() {

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

/*  removeStringToSF() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('SFEmail', "");
    prefs.setString('SFPass', "");
    prefs.setBool('SFRemember',false);
  }*/
}
