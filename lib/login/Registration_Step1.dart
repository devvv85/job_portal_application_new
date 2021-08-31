import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/forgot%20password/ResetPasswordActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:job_portal_application/login/Registration_Step2.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../MyColor.dart';

String email1 = "";

class Registration_Step1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
  Registration_Step1(String email)
  {
    email1 = email;
    print('emailmm $email1');
  }
}

class _State extends State<Registration_Step1> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 30),
                  child: Center(
                    child: Text(
                      'Step 1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:  MyColor.colorprimary),
                    ),
                  ),
                ),
                new Center(
                  child: new ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    // this will take space as minimum as posible(to center)
                    children: <Widget>[
                      new MaterialButton(
                        onPressed: () {},
                        color:  MyColor.colorprimary,
                        textColor: Colors.white,
                        child: Center(
                          child: Text(
                            '1',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        padding: EdgeInsets.all(17),
                        shape: CircleBorder(),
                      ),
                      new MaterialButton(
                        onPressed: () {},
                        color: Colors.white60,
                        textColor: Colors.black26,
                        child: Center(
                          child: Text(
                            '2',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black26),
                          ),
                        ),
                        padding: EdgeInsets.all(17),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Check Your Mail !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  child: Center(
                    child: Text(
                      'We have sent an activation link',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            color:  MyColor.colorprimary,
                            height: 36,
                          )),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5),
                  child: Center(
                    child: Text(
                      'For any queries Contact us',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 5.0, bottom: 10),
                  child: Center(
                    child: Text(
                      'info@jobcurator.in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    height: 48,
                    margin: const EdgeInsets.only(top: 5.0, bottom: 30),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:  MyColor.colorprimary,
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: ()
                      {
                      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Registration_Step2()),);
                        apiGetVariStatus(email1);
                      },
                    )),
              ],
            )));
  }

  apiGetVariStatus(String email) async {
    Map data = {"email": email};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.vari, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];

      print(jsonData);
      if (status == "1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Registration_Step2(),
              ));
        });
      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      }
    } else {}
  }
}
