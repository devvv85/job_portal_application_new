import 'package:flutter/material.dart';
import 'package:job_portal_application/Job%20Sharing/ExperienceActivity.dart';
import 'package:job_portal_application/forgot%20password/ResetPasswordActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:toast/toast.dart';

import '../MyColor.dart';

class Registration_Step2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Registration_Step2> {
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
                      'Step 2',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: MyColor.colorprimary),
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
                        color: Colors.white60,
                        textColor: Colors.black26,
                        child: Center(
                          child: Text(
                            '1',
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
                      new MaterialButton(
                        onPressed: () {},
                        color: MyColor.colorprimary,
                        textColor: Colors.white,
                        child: Center(
                          child: Text(
                            '2',
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
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 30.0, bottom: 10),
               child:MaterialButton(
                  onPressed: () {},
                  color:  MyColor.colorprimary,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.check,
                    size: 30,
                  ),
                  padding: EdgeInsets.all(27.0),
                //  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
               //   margin: const EdgeInsets.only(top: 15.0),
                  shape: CircleBorder(),
                ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                  height: 48,
                  margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: Center(
                    child: Text(
                      'Verified',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:  MyColor.colorprimary),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                    height: 48,
                    margin: const EdgeInsets.only(top: 25.0, bottom: 30),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:  MyColor.colorprimary,
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ExperienceActivity()),
                        );
                      },
                    )),
              ],
            )));
  }
}
