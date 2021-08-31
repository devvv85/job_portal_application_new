import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/DashboardActivity.dart';
import 'package:job_portal_application/DashboardScreens/Notifications.dart';
import 'package:job_portal_application/DashboardScreens/PostedJobList.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

import '../MyColor.dart';

List<String> isChecked = [];
List<String> isTechnologyChecked = [];
String struserType = "";
bool _isSortVisible = true;
bool _islocationVisible = false, _isIndustriesVisible = false;
String radioSortVal = "";
int _groupValue = 0;
var userStatus_loc_fil = List<bool>();
var userStatus_skill_fil = List<bool>();
String sortby;
String struserType1, selectedSkill1;
String selectedLoc, selectedTechnology;

class filters extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<filters> {
  List<User> users = new List<User>();
  List<IndustrygetSet> industry = new List<IndustrygetSet>();

  /*int _groupValue = -1;*/
  // int _groupValue = 1;

  @override
  void initState() {
    setState(() {
      setState(() {
        /* sortby = "";
        selectedLoc = "";
        selectedTechnology = "";
        isTechnologyChecked.clear();
        isChecked = [];
        isTechnologyChecked = [];
        isChecked.clear();
        users.clear();
        industry.clear();
        users = new List<User>();
        industry = new List<IndustrygetSet>();*/

        // userStatus_loc_fil.clear();
      });

      _getUusers();
      _getIndustries();
      _isSortVisible = true;
      _islocationVisible = false;
      _isIndustriesVisible = false;
    });
  }

  Future<Album> _getUusers() async {
    final response = await http.get(uidata.chooseLocation);
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(() {
        users = res.data;
        userStatus_loc_fil.add(false);
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }

  //get Industry list
  Future<Industry> _getIndustries() async {
    final response = await http.get(uidata.chooseSkills);
    if (response.statusCode == 200) {
      var res = Industry.fromJson(jsonDecode(response.body));
      setState(() {
        industry = res.industrygetSet;
        userStatus_skill_fil.add(false);
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5DDD5),
        body: Padding(
          padding: EdgeInsets.all(1),
          child: ListView(children: <Widget>[
            Container(
              height: 10,
              padding: EdgeInsets.all(3),
              margin: const EdgeInsets.only(
                  left: 7.0, right: 7.0, bottom: 5.0, top: 7.0),
/*              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),*/
            ),
            IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isSortVisible = true;
                              _islocationVisible = false;
                              _isIndustriesVisible = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(28),
                            margin: const EdgeInsets.only(),
                            width: 150,
                            height: 120,
                            child: Image.asset('assets/images/sort.png'),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isSortVisible = false;
                              _isIndustriesVisible = false;
                              _islocationVisible = true;
                              _getUusers();
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(28),
                              margin: const EdgeInsets.only(bottom: 5.0),
                              width: 160,
                              height: 120,
                              child:
                                  Image.asset('assets/images/locations.png')),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isSortVisible = false;
                              _isIndustriesVisible = true;
                              _islocationVisible = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(28),
                              margin: const EdgeInsets.only(),
                              width: 150,
                              height: 120,
                              child: Image.asset(
                                  'assets/images/technologies.png')),
                        ),
                      ]),
                    ),
                    /*          Expanded(
                      child: Container(
                        color: Colors.white60,
                        margin: const EdgeInsets.only(top: 10.0),
                        //*****************************************************************************************************************************************************

                        child:Visibility (
                          visible: _isSortVisible,
                        child: Column(
                          children: <Widget>[
                            _myRadioButton(
                              title: "Relevance",
                              value: 0,
                              onChanged: (newValue) =>
                                  setState(() => _groupValue = newValue),),
                            _myRadioButton(
                              title: "Freshness",
                              value: 1,
                              onChanged: (newValue) => setState(() => _groupValue = newValue),
                            ),
                          ],
                        ),
                      ),


                        //******************************************************************************************************************************************************
                      ),
                    ),*/


           */
           */
                    Expanded(
                      flex: 6,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            /*   color: Colors.white60,
                        margin: const EdgeInsets.only(top: 10.0),*/
                            //*****************************************************************************************************************************************************
                            Visibility(
                              visible: _isSortVisible,
                              child: Container(
                                height: 370,
                                color: Colors.white60,
                                child: Column(
                                  children: <Widget>[
                                    _myRadioButton(
                                      title: "Relevance",
                                      value: 0,
                                      onChanged: (newValue) => setState(
                                          () => _groupValue = newValue),
                                    ),
                                    _myRadioButton(
                                      title: "Freshness",
                                      value: 1,
                                      onChanged: (newValue) => setState(
                                          () => _groupValue = newValue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _islocationVisible,
                              child: Container(
                                color: Colors.white60,
                                height: 370,
                                // child: Flexible(
                                child: ListView.builder(
                                    //  shrinkWrap: true,
                                    //  primary: true,
                                    itemCount: users.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                          users[index].city_name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: MyColor.colorprimary,
                                          ),
                                        ),
                                        leading: Checkbox(
                                            value: userStatus_loc_fil[index],
                                            onChanged: (bool val) {
                                              setState(() {
                                                userStatus_loc_fil[index] =
                                                    !userStatus_loc_fil[index];
                                                if (val) {
                                                  if (isChecked.length > 0) {
                                                    for (int k = 0;
                                                        k < isChecked.length;
                                                        k++) {
                                                      if (users[index]
                                                              .city_name ==
                                                          isChecked[k]) {
                                                        /*  isChecked.remove(users[index].city_name);
                                                              isChecked.add(users[index].city_name);*/
                                                        break;
                                                      } else {
                                                        isChecked.add(
                                                            users[index]
                                                                .city_name);
                                                        break;
                                                      }
                                                    }
                                                  } else {
                                                    isChecked.add(
                                                        users[index].city_name);
                                                  }
                                                } else {
                                                  //  isChecked.remove(users[index].id);
                                                  isChecked.remove(
                                                      users[index].city_name);
                                                }
                                              });
                                            }),
                                        onTap: () {},
                                      );
                                    }),
                              ),
                            ),
                            // ),

                            Visibility(
                              visible: _isIndustriesVisible,
                              child: Container(
                                color: Colors.white60,
                                height: 370,
                                //  child: Flexible(
                                child: ListView.builder(
                                    //  shrinkWrap: true,
                                    //  primary: true,
                                    itemCount: industry.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                          industry[index].tech_name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: MyColor.colorprimary,
                                          ),
                                        ),
                                        leading: Checkbox(
                                            value: userStatus_skill_fil[index],
                                            onChanged: (bool val) {
                                              setState(() {
                                                userStatus_skill_fil[index] =
                                                    !userStatus_skill_fil[
                                                        index];
                                                if (val) {
                                                  // isTechnologyChecked.add(industry[index].tech_name);
                                                  if (isTechnologyChecked
                                                          .length >
                                                      0) {
                                                    for (int k = 0;
                                                        k <
                                                            isTechnologyChecked
                                                                .length;
                                                        k++) {
                                                      if (industry[index]
                                                              .tech_name ==
                                                          isTechnologyChecked[
                                                              k]) {
                                                        /*isTechnologyChecked.remove(industry[index].tech_name);
                                                        isTechnologyChecked.add(industry[index].tech_name);*/
                                                        break;
                                                      } else {
                                                        isTechnologyChecked.add(
                                                            industry[index]
                                                                .tech_name);
                                                        break;
                                                      }
                                                    }
                                                  } else {
                                                    isTechnologyChecked.add(
                                                        industry[index]
                                                            .tech_name);
                                                  }
                                                } else {
                                                  isTechnologyChecked.remove(
                                                      industry[index]
                                                          .tech_name);
                                                }
                                              });
                                            }),
                                        onTap: () {},
                                      );
                                    }),
                              ),
                            ),
                            // ),

                            //******************************************************************************************************************************************************
                          ]),
                    )
                  ]),
            ),
            Container(
                /* padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),*/
                padding: EdgeInsets.all(3),
                height: 48,
                margin: const EdgeInsets.only(
                    left: 9.0, right: 9.0, bottom: 5.0, top: 20.0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: MyColor.colorprimary,
                  child: Text(
                    'Set Preferences',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    // sortby;
                    if (_groupValue == 0) {
                      sortby = "relevance";
                    } else {
                      sortby = "freshness";
                    }
                    //  Toast.show(sortby, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                    /* for(int i=0;i<isChecked.length;i++)
                    {
                   */ /*   Toast.show(isChecked[i], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/ /*
                      selectedLoc=isChecked[i];
                    }*/
                    if (isChecked.length > 0) {
                      for (int i = 0; i < isChecked.length; i++) {
                        if (i == 0) {
                          selectedLoc = isChecked[i];
                        } else {
                          selectedLoc = selectedLoc + "," + isChecked[i];
                          print("ccc>>$selectedLoc $sortby");
                        }
                      }
                    } else {
                      selectedLoc = "";
                    }
                    //to get technology
                    if (isTechnologyChecked.length > 0) {
                      for (int i = 0; i < isTechnologyChecked.length; i++) {
                        if (i == 0) {
                          selectedTechnology = isTechnologyChecked[i];
                        } else {
                          selectedTechnology =
                              selectedTechnology + "," + isTechnologyChecked[i];
                          print("ccc>>$selectedTechnology $sortby");
                        }
                      }
                    } else {
                      selectedTechnology = "";
                    }
                    print("parameter$sortby$selectedLoc$selectedTechnology");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardActivity(sortby, selectedLoc, "", selectedTechnology)),
                    );

                    /*  setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostedJob(sortby,selectedLoc)),);

                    });*/
                    /*  setState(()
                    {
                      PostedJob(sortby,selectedLoc);
                    });*/
                  },
                )),
            Container(
                /* padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),*/
                padding: EdgeInsets.all(3),
                height: 48,
                margin: const EdgeInsets.only(
                    left: 9.0, right: 9.0, bottom: 5.0, top: 10.0),
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.grey,
                    child: Text(
                      'Clear Filter',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      setState(() {
                        sortby = "";
                        selectedLoc = "";
                        selectedTechnology = "";
                        isTechnologyChecked.clear();
                        isChecked = [];
                        isTechnologyChecked = [];
                        isChecked.clear();
                        userStatus_loc_fil.clear();
                        userStatus_skill_fil.clear();
                        users.clear();
                        industry.clear();
                        users = new List<User>();
                        industry = new List<IndustrygetSet>();
                        print("parameter$sortby$selectedLoc$selectedTechnology");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardActivity(sortby, selectedLoc, "", selectedTechnology)));
                      });
                    }))
          ]),
        ));
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
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
        title: Text(user.city_name),
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
        userStatus_loc_fil.add(false);
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

/////////////////////////////////////////Industries
class Industry {
  String status;
  List<IndustrygetSet> industrygetSet;

  Industry({this.status, this.industrygetSet});

  Industry.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      industrygetSet = new List<IndustrygetSet>();
      json['data'].forEach((v) {
        industrygetSet.add(new IndustrygetSet.fromJson(v));
        userStatus_skill_fil.add(false);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.industrygetSet != null) {
      data['data'] = this.industrygetSet.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IndustrygetSet {
  String id;
  String tech_name;
  String status;

  IndustrygetSet({this.id, this.tech_name, this.status});

  IndustrygetSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tech_name = json['tech_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tech_name'] = this.tech_name;
    data['status'] = this.status;
    return data;
  }
}
