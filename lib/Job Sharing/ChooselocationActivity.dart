import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/Job%20Sharing/ExperienceMonth_YearActivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../DashboardActivity.dart';
import '../MyColor.dart';

SharedPreferences prefs;
var userStatus = List<bool>();
List<String> isChecked = [];
String struserType1, selectedSkill1, userId;
String selectedLoc = "";

class ChooseLocationActivity extends StatefulWidget {
  /* ChooseLocationActivity({Key key, this.title}) : super(key: key);
  final String title;*/

  @override
  _MyHomePageState createState() => _MyHomePageState();

  ChooseLocationActivity(String struserType, String selectedSkill)
  {
    struserType1 = struserType;
    selectedSkill1 = selectedSkill;
    print('usertype $struserType1');
    print('skill $selectedSkill1');
  }
}

class _MyHomePageState extends State<ChooseLocationActivity>
{
  List<User> users = new List<User>();
  TextEditingController editingController = TextEditingController();

  @override
  void initState()
  {
    _getUusers();
    setState(()
    {
      initializeSF();
    });
  }

  Future<Album> _getUusers() async {
    final response = await http.get(uidata.chooseLocation);
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(() {
        users = res.data;
        userStatus.add(false);
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }
  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    print("id $userId");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Job Sharing'),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Container(
                height: 65,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                child: RaisedButton(
                  textColor: MyColor.colorprimary,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color:  MyColor.colorprimary,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(2)),
                  child: Text(
                    'Choose Your Locations',
                    style: TextStyle(
                        fontSize: 19,
                        color: MyColor.colorprimary,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                )),
            Container(
              height: 65,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 9, right: 9),
              // padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value)
                {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              ),
            ),

            //Scrollbar(child:
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    if (editingController.text.isEmpty) {
                      return ListTile(
                        title: Text(users[index].city_name),
                        leading: Checkbox(
                            value: userStatus[index],
                            onChanged: (bool val) {
                              setState(() {
                               userStatus[index] = !userStatus[index];
                                if (val) {
                                  isChecked.add(users[index].city_name);
                                } else {
                                  isChecked.remove(users[index].city_name);
                                }
                              });
                            }),
                        onTap: () {},
                      );
                    } else if (users[index]
                            .city_name
                            .toLowerCase()
                            .contains(editingController.text) ||
                        users[index]
                            .city_name
                            .toLowerCase()
                            .contains(editingController.text)) {
                      return ListTile(
                        title: Text(users[index].city_name),
                        leading: Checkbox(
                            value: userStatus[index],
                            onChanged: (bool val) {
                              setState(() {
                                userStatus[index] = !userStatus[index];
                                if (val) {
                                  isChecked.add(users[index].city_name);
                                } else {
                                  isChecked.remove(users[index].city_name);
                                }
                              });
                            }),
                        onTap: () {},
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                height: 65,
                child: RaisedButton(
                  textColor: Colors.white,
                  color:  MyColor.colorprimary,
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    print("ddd${isChecked.length}");
                  if(isChecked.length>0)
                    for (int i = 0; i < isChecked.length; i++)
                    {
                      if (i == 0)
                      {
                        selectedLoc = isChecked[i];
                      } else
                        {
                        selectedLoc = selectedLoc + "," + isChecked[i];
                        print("cc$selectedLoc");
                      }
                    }
                    if(selectedLoc.isEmpty)
                    {
                      Toast.show("Please select location", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {

                      if (struserType1 == "Fresher")
                      {
                        apiUpdateProfile(userId, struserType1, selectedSkill1, selectedLoc, "", "");
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExperienceMonth_YearActivity(struserType1, selectedSkill1, selectedLoc)),
                        );
                      }
                    }
                  },
                )),
          ],
        )));



  }

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
    print(data);print("ghhghg");
    var jsonData = null;
    var response = await http.post(uidata.UpdateProfile, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];

      print('resssssss$jsonData');
      if (status == "1") {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity("", "",id,"")),);
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {

    }
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.city_name),
        backgroundColor: MyColor.colorprimary,
      ),
      body: Container(
        child: Text(user.city_name),
      ),
    );
  }
}

class Album {
  String status;
  List<User> data;

  Album({this.status, this.data});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
        userStatus.add(false);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String id;
  String city_name;
  String status;

  User({this.id, this.city_name, this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city_name = json['city_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_name'] = this.city_name;
    data['status'] = this.status;
    return data;
  }
}
