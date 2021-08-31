import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

import '../MyColor.dart';
import 'ChooselocationActivity.dart';

var userStatus = List<bool>();
List<String> isChecked = [];
String struserType = "";
String selectedSkill = "";

class ChooseSkillActivity extends StatefulWidget {
  // ChooseSkillActivity({Key key, this.title}) : super(key: key);
  //final String title;
  TextEditingController editingController = TextEditingController();

  ChooseSkillActivity(String strUser) {
    struserType = strUser;
    print('a $struserType');
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChooseSkillActivity> {
  /* var userStatus = List<bool>();*/
  List<User> users = new List<User>();
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    _getUusers();
  }

  Future<Album> _getUusers() async {
    final response = await http.get(uidata.chooseSkills);
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(() {
        users = res.data;
        userStatus.add(false);
      });
    } else {
      throw Exception('Failed to load skills');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Job Sharing"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 65,
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                    'Choose Your Skills',
                    style: TextStyle(
                        fontSize: 19,
                        color:  MyColor.colorprimary,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                )),
            Container(
              height: 65,
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 7, right: 7),
              // padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    if (editingController.text.isEmpty) {
                      return ListTile(
                        title: Text(users[index].techName),
                        leading: Checkbox(
                            value: userStatus[index],
                            onChanged: (bool val) {
                              setState(() {
                                userStatus[index] = !userStatus[index];
                                if (val) {
                                  isChecked.add(users[index].techName);
                                } else {
                                  isChecked.remove(users[index].techName);
                                }
                              });
                            }),
                        onTap: () {},
                      );
                    } else if (users[index]
                            .techName
                            .toLowerCase()
                            .contains(editingController.text) ||
                        users[index]
                            .techName
                            .toLowerCase()
                            .contains(editingController.text))
                    {
                      return ListTile(
                        title: Text(users[index].techName),
                        leading: Checkbox(
                            value: userStatus[index],
                            onChanged: (bool val) {
                              setState(() {
                                userStatus[index] = !userStatus[index];
                                if (val) {
                                  isChecked.add(users[index].techName);
                                } else {
                                  isChecked.remove(users[index].techName);
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
                padding: EdgeInsets.only(top: 10, bottom: 10),
                height: 62,
                child: RaisedButton(
                  textColor: Colors.white,
                  color:  MyColor.colorprimary,
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    print("aaa${isChecked.length}");
                    if (isChecked.length > 0) {
                      for (int i = 0; i < isChecked.length; i++)
                      {
                        if (i == 0)
                        {
                          selectedSkill = isChecked[i];
                        } else
                          {
                          selectedSkill = selectedSkill + "," + isChecked[i];
                          print("bbb$selectedSkill");
                        }
                      }
                    }
                    if (selectedSkill.isEmpty) {
                      Toast.show("Please choose skill", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseLocationActivity(struserType, selectedSkill)),
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.techName),
        backgroundColor: MyColor.colorprimary,
      ),
      body: Container(
        child: Text(user.techName),
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
  String techName;
  String status;

  User({this.id, this.techName, this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    techName = json['tech_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tech_name'] = this.techName;
    data['status'] = this.status;
    return data;
  }
}
