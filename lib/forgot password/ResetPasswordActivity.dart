import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../MyColor.dart';

String email = "";

class ResetPasswordActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  ResetPasswordActivity(String email1) {
    email = email1;
  }
}

class _State extends State<ResetPasswordActivity> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

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
                      'Reset Your Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
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
                      'What would you like your new password to be ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  /*height: 57*/
                  height: 53,
                  padding: EdgeInsets.all(4),
                  child: TextField(
                    obscureText: !this._showPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                      //prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: this._showPassword ?  MyColor.colorprimary : Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                                  () =>
                              this._showPassword = !this._showPassword);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 53,
                  padding: EdgeInsets.all(4),
                  child: TextField(
                    obscureText: !this._showConfirmPassword,
                    controller: confirmpasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      //prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: this._showConfirmPassword
                              ?  MyColor.colorprimary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() =>
                          this._showConfirmPassword =
                          !this._showConfirmPassword);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  /* padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),*/
                    padding: EdgeInsets.all(4),
                    height: 48,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:  MyColor.colorprimary,
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (passwordController.text.isEmpty)
                        {
                          Toast.show("Please enter password", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                        else if(confirmpasswordController.text.isEmpty)
                          {
                            Toast.show("Please enter confirm password", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        else if(passwordController.text !=confirmpasswordController.text)
                          {
                            Toast.show("Confirm not match with password.", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                          }
                        else {
                          apiResetPassword(email, passwordController.text);
                        }
                      },
                    )),
              ],
            )));
  }

  apiResetPassword(String email, String pass) async {
    Map data = {"email": email, "ps": pass};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.ResetPwd, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];
      var email = jsonData['data'];
      print(jsonData);
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      } else {
        Toast.show(msg, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
}
