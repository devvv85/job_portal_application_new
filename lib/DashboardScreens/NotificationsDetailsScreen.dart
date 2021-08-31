import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

import '../MyColor.dart';

List<String> isChecked = [];
String struserType = "";
String id1;

class NotificationDetails extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();

  NotificationDetails(String id) {
    id1 = id;
    print("id>>>$id1");
  }
}

class _MyHomePageState extends State<NotificationDetails> {
  List<User> users = new List<User>();

  @override
  void initState() {
    setState(() {
      _getNotifications();
    });

  }

  Future<Album> _getNotifications() async {
    Map data = {"not_id": id1};
   // final response = await http.post(uidata.NotificationDetails, body: data);
    var response = await http.post(uidata.NotificationDetails, body: data);
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(()
      {
        users = res.data;

      });
    } else {
      throw Exception('Failed to load details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications Details'),
          backgroundColor: MyColor.colorprimary,
        ),
        body: ListView.builder(
            shrinkWrap: true,

            itemCount: users.length,
            itemBuilder: (context, index) {
              return new Card(
                  color: Theme
                      .of(context)
                      .cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //  padding: EdgeInsets.all(15),
                                padding: EdgeInsets.only(
                                    left: 8, right: 7, bottom: 4, top: 10),
                                child: Text("Job Title : "+users[index].title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                    style: new TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 7, bottom: 4),
                                child:
                                Text('Message : ' + users[index].message,
                                    // overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 7, bottom: 4),
                                child: Text(
                                    'Date : ' + users[index].date1,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 7, bottom: 4),
                                child: Text(
                                    'Technology : ' + users[index].technology,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    )),
                              ),
                              Container(
                                //  padding: EdgeInsets.all(15),
                                padding: EdgeInsets.only(
                                    left: 8, right: 7, bottom: 4),
                                child:
                                Text('Role : ' + users[index].role,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                    style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    )),
                              ),

                            ],
                          ),
                        ),
                      ),
                      /* Divider(
                    color: Colors.blueGrey,
                  ),*/

                    ],
                  ));
            }));
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
