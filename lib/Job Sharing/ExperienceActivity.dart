import 'package:flutter/material.dart';
import 'package:job_portal_application/Job%20Sharing/ChooseSkillActivity.dart';
import 'package:job_portal_application/forgot%20password/ResetPasswordActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:toast/toast.dart';

import '../MyColor.dart';

class ExperienceActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ExperienceActivity> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Job Sharing'),
          backgroundColor: MyColor.colorprimary,
        ),
        body:
        Padding(
            padding: EdgeInsets.all(60),
            child: ListView(
              children: <Widget>[
                Container(
                    height: 75,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: RaisedButton(
                      textColor:  MyColor.colorprimary,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: MyColor.colorprimary,
                              width: 1,
                              style: BorderStyle.solid,),
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        'Fresher',
                        style: TextStyle(fontSize: 19, color:  MyColor.colorprimary,fontWeight:FontWeight.bold),
                      ),
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseSkillActivity("Fresher")),);

                      },
                    )),
                Container(
                    height: 75,
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
                        'Experienced',
                        style: TextStyle(fontSize: 19, color:  MyColor.colorprimary,fontWeight:FontWeight.bold),
                      ),
                      onPressed: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseSkillActivity("Experienced")),);
                        },
                    )),
              ],
            )));
  }


}
