import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/forgot%20password/ResetPasswordActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../MyColor.dart';
String email="";
class Forgotpass_checkmailActivity extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
  Forgotpass_checkmailActivity(String email1)
  {
    email=email1;
  }
}

class _State extends State<Forgotpass_checkmailActivity> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password'),
          backgroundColor: MyColor.colorprimary,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 25.0, bottom: 30),
                  child: Center(
                    child: Text(
                      'Check in Your Mail !',
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
                  margin: const EdgeInsets.only(top: 20.0, bottom: 30),
                  child: Center(
                    child: Text(
                      'We just emailed you with the instructions to reset your password',
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
                  margin: const EdgeInsets.only(top: 15.0, bottom: 20),
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
                  margin: const EdgeInsets.only(top: 5.0, bottom: 20),
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
                        apiforgotpassVerify(email);
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordActivity()),);
                      },
                    )),
              ],
            )));
  }
  apiforgotpassVerify(String email) async
  {
    Map data = {"email": email};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.forgotpass_verified, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];
     // var email = jsonData['data'];
      print(jsonData);
      if (status =="1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordActivity(email)),);
        });

      }
      else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordActivity(email)),);
      }
    } else {}
  }

}
