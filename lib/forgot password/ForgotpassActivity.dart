import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/forgot%20password/Forgotpass_checkmailActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../MyColor.dart';

class ForgotpassActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ForgotpassActivity> {
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
                  //height: 57,
                  height: 53,
                  margin: const EdgeInsets.only(top: 95.0),
                  padding: EdgeInsets.all(4),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your Email',
                    ),
                  ),
                ),
                Container(height: 8.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 25.0, bottom: 30),
                  child: Center(
                    child: Text(
                      'Enter your e-mail address will send you a link to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(4),
                    height: 48,
                    margin: const EdgeInsets.only(top: 15.0, bottom: 30),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:  MyColor.colorprimary,
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
                        print(emailValid);
                        if (emailController.text.isEmpty) {
                          Toast.show("Please enter email id", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                        else if (emailValid == false)
                        {
                          Toast.show("Please enter valid email", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                        else {
                          apiLinksend(emailController.text);
                        }
                        /*  Navigator.push(context, MaterialPageRoute(builder: (context) => Forgotpass_checkmailActivity()),);*/
                      },
                    )),
              ],
            )));
  }

  //api call
  apiLinksend(String email) async {
    Map data = {"email": email};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.forgotpass_mailsending, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];

      print(jsonData);
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Forgotpass_checkmailActivity(emailController.text)),
          );
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Forgotpass_checkmailActivity(emailController.text)),);
      }
    } else {}
  }
}
