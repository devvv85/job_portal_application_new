import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/DashboardActivity.dart';
import 'package:job_portal_application/Job%20Sharing/ExperienceActivity.dart';
import 'package:job_portal_application/MyColor.dart';
import 'package:job_portal_application/forgot%20password/ForgotpassActivity.dart';
import 'package:job_portal_application/login/Registration.dart';
import 'package:job_portal_application/sociallogin/Experience_sociallogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

SharedPreferences prefs;
bool rememberMe = false;
String email, pass, loginnm, loginemail;
bool isRemember = false;
String token = "";

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  bool checkedValue = true;
  bool valuefirst = false;
  bool valuesecond = false;

  //var  login

  bool _isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

/*
  _login() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      await _googleSignIn.signIn();
      setState(()
      {
        _isLoggedIn = true;
        loginnm = _googleSignIn.currentUser.displayName;
        loginemail = _googleSignIn.currentUser.email;
        apiGoogleLogin(loginnm, loginemail, token);
      });
    } catch (err) {
   */
/*   loginnm="jyoti";loginemail="jyotigame92@gmail.com";
      apiGoogleLogin(loginnm, loginemail, token);*//*

      print("errorrrr>>$err");
    }
  }
*/

  _login() async {
    try
    {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      await _googleSignIn.signIn();
      setState(() async
      {
        _isLoggedIn = true;
        loginnm = _googleSignIn.currentUser.displayName;
        loginemail = _googleSignIn.currentUser.email;
      //  photourl = _googleSignIn.currentUser.photoUrl;
        prefs = await SharedPreferences.getInstance();
        setState(()
        {
          token = prefs.getString('devicetoken');
          print('token1 $token');
        });
        apiGoogleLogin(loginnm, loginemail, token);
      });
    } catch (err) {
      print("errorrrr>>$err");
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(()
    {
      _isLoggedIn = false;
    });
  }
  @override
  void initState()
  {
    super.initState();
    initializeSF();
    getStringFromSF();

  }
  @override
  Widget build(BuildContext context)
  {
    return new WillPopScope(
        onWillPop: ()
    {
      Navigator.pop(context);
    exit(0);
      return Future.value(true);
    },

        child:  Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: MyColor.colorprimary,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: EdgeInsets.all(14),
            child: ListView(
              children: <Widget>[
                Container(
                    width: 160,
                    height: 125,
                    child: Image.asset('assets/images/logo.png')),
                Container(
                  height: 49,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !this._showPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
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
                //  ),

                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Remember Me ',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Checkbox(
                      checkColor: Colors.greenAccent,
                      activeColor: MyColor.colorprimary,
                      value: valuefirst,
                      //value: rememberMe,
                      onChanged: (bool value) {
                        initializeSF();

                        /* email=prefs.getString("SFEmail");
                        pass=prefs.getString("SFPass");*/
                        setState(() {
                          this.valuefirst = value;
                          // isRemember = value;
                          /*  prefs.setBool('SFRemember',value);*/
                          if (valuefirst == true) {
                            initializeSF();
                            addStringToSF();
                            //  prefs.setBool('SFRemember',true);
                            /* nameController.clear();
                            passwordController.clear();C
                            getStringFromSF();*/
                          } else {
                            addIsLoginToSF();
                            // prefs.setBool('SFRemember',false);
                          }
                        });
                      },
                    ),
                  ],
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.only(top: 4),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: MyColor.colorprimary,
                      child: Text(
                        'Login',
                        //style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      onPressed: () async {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(nameController.text);

                        if (nameController.text.isEmpty) {
                          Toast.show("Please enter email", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else if (emailValid == false) {
                          Toast.show("Please enter valid email", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else if (passwordController.text.isEmpty) {
                          Toast.show("Please enter password", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else {
                          prefs = await SharedPreferences.getInstance();
                          setState(() {
                            token = prefs.getString('devicetoken');
                            print('token1 $token');
                          });

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity("","","1")),);
                          if (token == null) {
                            token = "";
                          } else {
                            apiLogin(nameController.text,
                                passwordController.text, token);
                          }
                        }
                      },
                    )),
                Container(
                    height: 65,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: RaisedButton(
                      textColor: MyColor.colorprimary,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: MyColor.colorprimary,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        'Forgot  Password',
                        style: TextStyle(
                            fontSize: 17,
                            color: MyColor.colorprimary,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotpassActivity()),
                        );
                      },
                    )),
                SignInButton(
                  Buttons.Google,
                  padding: EdgeInsets.only(top: 10),
                  //  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  mini: false,
                  onPressed: () async {
                    //_showButtonPressDialog(context, 'Google');
                    prefs = await SharedPreferences.getInstance();
                    setState(() {
                      token = prefs.getString('devicetoken');
                      print('token1 $a');
                    });
                    _login();
                  },
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text(
                      'Do not have an account?',
                      /*style: TextStyle(fontSize: 17),*/
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    FlatButton(
                      textColor: MyColor.colorprimary,
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            ))));
  }

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
  }

  addStringToSF() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('SFEmail', nameController.text);
    prefs.setString('SFPass', passwordController.text);
    prefs.setBool('SFRemember', true);
    prefs.setBool('SFIsLogin', false);
  }

  addIsLoginToSF() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('SFRemember', false);
    prefs.setBool('SFIsLogin', false);
  }

  addIsLoginTrueToSF() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('SFIsLogin', true);
  }

  getStringFromSF() async
  {
    prefs = await SharedPreferences.getInstance();

    //  nameController.text ="a";
    // passwordController.text = "b";
    if (prefs.getBool('SFIsLogin') == true &&
        prefs.getBool('SFRemember') == true) {
      email = prefs.getString('SFEmail');
      pass = prefs.getString('SFPass');
      isRemember = prefs.getBool('SFRemember');
      print('hhhhhhhhhhhhhhhhhhhhhhhhhh');
      print(isRemember);
      nameController.text = email;
      passwordController.text = pass;
    } else {
      isRemember = false;
    }
  }

  //api call
  apiLogin(String email, String pass, String token) async
  {
    Map data = {"email": email, "ps": pass, "token": token};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.login, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];

      print(jsonData);
      if (status == "1") {
        addIsLoginTrueToSF();
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        var uId = jsonData['id'];
        var uName = jsonData['name'];

        prefs = await SharedPreferences.getInstance();
        setState(()
        {
          prefs.setString('uId', uId);
          prefs.setString('uName', uName);
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity("", "", uId, "")),);
        });
      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  //api google login
  apiGoogleLogin(String nm, String email, String token) async {
    Map data = {"fname": nm, "email": email, "token": token};
    print("login$data");
    var jsonData = null;
    var response = await http.post(uidata.GoogleLogin, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];
      var isnew = jsonData['isnew'].toString();

      print("Res>>$jsonData");
      if (status == "1")
      {
        addIsLoginTrueToSF();

        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        var uId = jsonData['id'].toString();
        var uName = nm;

        prefs = await SharedPreferences.getInstance();
        prefs.setString('uId', uId);
        prefs.setString('uName', uName);

       if(isnew=="true")
       {
         setState(() {

        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExperienceSociallogin(uId.toString())),);

           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExperienceActivity()),);

         });
       }
        else
          {
            setState(()
            {
              prefs.setString('uId', uId);
              prefs.setString('uName', uName);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity("", "", uId, "")),);
            });
          }
      }
      else
        {
          Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
    } else
      {
         print("elseee");
      }
  }
}
