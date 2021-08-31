import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/DashboardScreens/NotificationsDetailsScreen.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

List<String> isChecked = [];
String struserType = "";
bool isLoadings1 = false;

class NotificationList extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NotificationList> {
  List<User> users = new List<User>();

  @override
  void initState() {
    isLoadings1 = true;
    _getNotifications();
  }

  Future<Album> _getNotifications() async {
    final response = await http.get(uidata.Notifications);
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(() {
        users = res.data;
        isLoadings1 = false;
      });
    } else {
      throw Exception('Failed to load skills');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:new GestureDetector(
        child: Container(
            child: Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 7,
          margin: const EdgeInsets.only(bottom: 6),
        ),
        isLoadings1
            ? Container(
                margin: const EdgeInsets.only(left: 29.0, right: 29, top: 250),
                color: Colors.white.withOpacity(.4),
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              )
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          /*title: Text(
                    users[index].title,
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),*/
                          title: Container(
                            padding: EdgeInsets.only(top: 2, bottom: 5),
                            child: Text(
                              users[index].title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Column(
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                    users[index].message == "" ||
                                            users[index].message == null
                                        ? "Description : None"
                                        : "Description : " +
                                            users[index].message,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  padding: EdgeInsets.all(2.0),
                                  child: Text(
                                    'Date : ' + users[index].date1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black),
                                  ),
                                ),
                              ),
                              /* SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          child: Text('Role : '+
                            users[index].role,
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                        ),
                      ),*/
/*                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
'Technology : '+
                            users[index].technology,

                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),

                          ),
                        ),
                      ),*/
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationDetails(users[index].id)),
                            );
                          },
                        ),
                      );
                    }),
              ),
      ],
    ))));
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.title),
      ),
      body: Container(
        child: Text(user.title),
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
        // userStatus.add(false);
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
  String title;
  String message, date1, role, technology;

  User(
      {this.id,
      this.title,
      this.message,
      this.date1,
      this.role,
      this.technology});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    date1 = json['date1'];
    role = json['role'];
    technology = json['technology'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['date1'] = this.date1;
    data['role'] = this.role;
    data['technology'] = this.technology;
    return data;
  }
}
