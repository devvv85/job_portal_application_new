import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/Job%20Sharing/ChooseSkillActivity.dart';
import 'package:job_portal_application/forgot%20password/ResetPasswordActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:job_portal_application/sociallogin/experienceinyears_sociallogin.dart';
import 'package:toast/toast.dart';

import '../DashboardActivity.dart';
import '../MyColor.dart';
import 'package:http/http.dart' as http;
String userId;
class ExperienceSociallogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
  ExperienceSociallogin(String userId1)
  {
    userId=userId1;
  }
}

class _State extends State<ExperienceSociallogin>
{
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
                       apiUpdateProfile(userId, "Fresher", "", "", "", "");
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => experiencesocialogin("Experienced","","")),);
                      },
                    )),
              ],
            )));
  }

  apiUpdateProfile(String id, String usertype, String skill, String location, String exp_month, String exp_year) async {
    Map data =
    {
      "id": id,
      "usertype": usertype,
      "skill": skill,
      "location": location,
      "exp_month": exp_month,
      "exp_year": exp_year
    };
    print("para_updateprof>>$data");
    var jsonData = null;
    var response = await http.post(uidata.UpdateProfile, body: data);

    if(response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];

      print(jsonData);
      if (status == "1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity("","",id,"")),);
        });
      } else
        {
          Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
    } else {}
  }

}
