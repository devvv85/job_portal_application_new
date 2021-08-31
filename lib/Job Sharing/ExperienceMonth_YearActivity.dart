import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/DashboardActivity.dart';
import 'package:job_portal_application/forgot%20password/ResetPasswordActivity.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../MyColor.dart';

String struserType1, selectedSkill1, selectedLoc1,strMonth,strYear;
SharedPreferences prefs;
class ExperienceMonth_YearActivity extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();

  ExperienceMonth_YearActivity(String struserType, String selectedSkill, String selectedLoc) {
    struserType1 = struserType;
    selectedSkill1 = selectedSkill;
    selectedLoc1 = selectedLoc;

    print('struserType $struserType1');
    print('selectedSkill $selectedSkill1');
    print('selectedLoc $selectedLoc1');
  }

}

class _State extends State<ExperienceMonth_YearActivity> {
  TextEditingController emailController = TextEditingController();
  Item selectedmonth, selectedyear;

  /*List<Item> users = <Item>[
    const Item('Android',Icon(Icons.android,color:  const Color(0xFF167F67),)),
    const Item('Flutter',Icon(Icons.flag,color:  const Color(0xFF167F67),)),
    const Item('ReactNative',Icon(Icons.format_indent_decrease,color:  const Color(0xFF167F67),)),
    const Item('iOS',Icon(Icons.mobile_screen_share,color:  const Color(0xFF167F67),)),
  ];*/
  List<Item> month = <Item>[
    const Item('1', 'Month'),
    const Item('2', 'Month'),
    const Item('3', 'Month'),
    const Item('4', 'Month'),
    const Item('5', 'Month'),
    const Item('6', 'Month'),
    const Item('7', 'Month'),
    const Item('8', 'Month'),
    const Item('9', 'Month'),
    const Item('10', 'Month'),
    const Item('11', 'Month'),
    const Item('12', 'Month')
  ];
  List<Item> year = <Item>[
    const Item('1', 'Year'),
    const Item('2', 'Year'),
    const Item('3', 'Year'),
    const Item('4', 'Year'),
    const Item('5', 'Year'),
    const Item('6', 'Year'),
    const Item('7', 'Year'),
    const Item('8', 'Year'),
    const Item('9', 'Year'),
    const Item('10', 'Year'),
    const Item('11', 'Year'),
    const Item('12', 'Year'),
  ];

  void initState()
  {
    setState(() {
      initializeSF();
    });
  }
  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("uId");
    print('Experience id $userId');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Job Sharing'),
          backgroundColor: MyColor.colorprimary,
        ),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: ListView(
              children: <Widget>[
                Container(
                    height: 85,
                    padding: EdgeInsets.only(top: 10, bottom: 30),
                    child: RaisedButton(
                      textColor:  MyColor.colorprimary,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:  MyColor.colorprimary,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        'Total years of experience',
                        style: TextStyle(
                            fontSize: 17,
                            color:  MyColor.colorprimary,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseSkillActivity()),);
                      },
                    )),
                /////////////*************************/////////

                IntrinsicHeight(
                  child: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //  crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(children: [
                            DropdownButton<Item>(
                              hint: Text("Years"),
                              value: selectedyear,
                              onChanged: (Item Value) {
                                setState(() {
                                  selectedyear = Value;
                                  strYear=Value.name;
                               //   Toast.show(strYear, context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                                });
                              },
                              items: year.map((Item year)
                              {
                                return DropdownMenuItem<Item>(
                                  value: year,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        year.name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(width: 35),
                                      Text(
                                        year.title,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: DropdownButton<Item>(
                            hint: Text("Months"),
                            value: selectedmonth,
                            onChanged: (Item Value)
                            {
                              setState(() {
                                selectedmonth = Value;
                                strMonth=Value.name;
                              //  Toast.show(strMonth, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                              });
                            },
                            items: month.map((Item user) {
                              return DropdownMenuItem<Item>(
                                value: user,
                                child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(width: 35),
                                    Text(
                                      user.title,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ]),
                ),

                Container(
                    padding: EdgeInsets.only(top: 60, bottom: 10),
                    height: 115,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:  MyColor.colorprimary,
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () /*async*/ {
                      /*  prefs = await SharedPreferences.getInstance();
                        String uId = prefs.getString('uId');*/

                        apiUpdateProfile(userId, struserType1, selectedSkill1, selectedLoc1,strMonth, strYear);

                      },
                    )),
              ],
            )));



  }

  //profile update
  apiUpdateProfile(String id, String usertype, String skill, String location,
      String exp_month, String exp_year) async {
    Map data = {
      "id": id,
      "usertype": usertype,
      "skill": skill,
      "location": location,
      "exp_month": exp_month,
      "exp_year": exp_year
    };
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.UpdateProfile, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];

      print(jsonData);
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardActivity("","",id,"")),
          );
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
}

class Item {
  const Item(this.name, this.title);

  final String name;
  final String title;
/* final Icon icon;*/
}
