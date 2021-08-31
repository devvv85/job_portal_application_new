import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:job_portal_application/login/Registration_Step1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../MyColor.dart';

SharedPreferences prefs;

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
          backgroundColor: MyColor.colorprimary,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  //height: 57,
                  height: 53,
                  padding: EdgeInsets.all(4),
                  margin: const EdgeInsets.only(top: 15.0),
                  child: TextField(
                    autofocus: true,
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name * ',
                    ),
                  ),
                ),
                Container(
                  //height: 57,
                  height: 53,
                  padding: EdgeInsets.all(4),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email *',
                    ),
                    // focusNode: myFocusNode,
                  ),
                ),
                Container(
                  //  height: 57,
                  height: 75,
                  padding: EdgeInsets.all(4),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: mobileController,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile No. *',
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
                      labelText: 'Password *',
                      //prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: this._showPassword
                              ? MyColor.colorprimary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(
                              () => this._showPassword = !this._showPassword);
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
                      labelText: 'Confirm Password *',
                      //prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: this._showConfirmPassword
                              ? MyColor.colorprimary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => this._showConfirmPassword =
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
                    margin: const EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: MyColor.colorprimary,
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        //temp changes

                        //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Registration_Step1(emailController.text,),));
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text);
                        print(emailValid);

                        if (nameController.text.isEmpty)
                        {
                          Toast.show("Please enter name", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (emailController.text.isEmpty) {
                          Toast.show("Please enter email id.", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (mobileController.text.isEmpty) {
                          Toast.show("Please enter mobile no.", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (emailValid == false) {
                          Toast.show("Please enter valid email", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (mobileController.text.length != 10) {
                          Toast.show(
                              "Mobile Number must be of 10 digit", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (passwordController.text.isEmpty) {
                          Toast.show("Please enter password", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (confirmpasswordController.text.isEmpty) {
                          Toast.show("Please enter confirm password", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else if (passwordController.text !=
                            confirmpasswordController.text) {
                          Toast.show(
                              "Confirm not match with password.", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.CENTER);
                        } else {
                          apiLogin(emailController.text, nameController.text,
                              mobileController.text, passwordController.text);
                        }
                      },
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Already have an account ?',
                          style: TextStyle(fontSize: 17),
                        ),
                        FlatButton(
                          textColor: MyColor.colorprimary,
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }

  //api call
  apiLogin(String email, String name, String mobileno, String pass) async {
    Map data = {"email": email, "name": name, "mno": mobileno, "ps": pass};
    print("para>>$data");
    var jsonData = null;
    var response = await http.post(uidata.signup, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];
      var email = jsonData['data'];
      print("Response>>$jsonData");
      print('status $status');
      if (status == "1") {
        var uId = jsonData['id'];
        var uName = jsonData['name'];
        prefs = await SharedPreferences.getInstance();
        prefs.setString('uId', uId);
        prefs.setString('uName', uName);
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        setState(() {
          /* Navigator.push(context, MaterialPageRoute(builder: (context) => Registration_Step1(),));*/
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Registration_Step1(email),
              ));
          clearfields();
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    } else {}
  }

  clearfields() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    passwordController.clear();
    confirmpasswordController.clear();
  }
}
