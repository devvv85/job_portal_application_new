import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/DashboardScreens/JobDetailsScreen.dart';
import 'package:job_portal_application/MyColor.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

final String description =
    "Flutter is Google’s mobile UI framework for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.";
List<String> isChecked = [];
String struserType = "";
String s = "yes";
String strSrotby, strLoc, userId;
SharedPreferences prefs;
String a = "java bangalore";
String strtech = "", id1;
bool isLoading = true;

class PostedJob extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();

  PostedJob(String sortby, String location, String tech) {
    strSrotby = sortby;
    strLoc = location;
    strtech = tech;
  }
}

class _MyHomePageState extends State<PostedJob> {
  List<User> users = new List<User>();
  Color _like_iconColor = Colors.grey;
  Color _fav_iconColor = Colors.grey;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    setState(() {
      initializeSF();
    });
  }

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    print('Posted job $userId');

    _getUusers();
  }

  Future<Album> _getUusers() async {
    Map data = {
      "sort": strSrotby,
      "loc_id": strLoc,
      "user_id": userId,
      "skill": strtech
    };
    print('para $data');
    final response = await http.post(uidata.JobLists, body: data);
    print("Response2>>>>>>$response");
    if (response.statusCode == 200) {
      //  print("body>>>>>>$jsonDecode(response.body).toString");

      var res = Album.fromJson(jsonDecode(response.body));

      print("Response3>>>>>>$res");
      setState(() {
        users = res.data;
        //   userStatus.add(false);
      });
    } else {
      throw Exception('Failed to load skills');
    }
  }

  ///add likes
  apiAddLikes(String id, String j_id) async {
    Map data = {
      "id": id,
      "j_id": j_id,
    };
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.AddLikes, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['staus'];
      var msg = jsonData['message'];

      print("Responce$jsonData");
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  ///
  /// Add to favourite
  apiAddFavourite(String id, String j_id) async {
    Map data = {
      "id": id,
      "j_id": j_id,
    };
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.AddFavourite, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['message'];
      print(jsonData);
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          _getUusers();
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  ///

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
              Container(
                // margin: const EdgeInsets.only(bottom:8),
                // color: Colors.pink,
                child: Container(
                  color: Colors.white,
                  height: 41,
                  margin: const EdgeInsets.only(left: 2, right: 2),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
              ),
              isLoading
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 29.0, right: 29, top: 80.0),
                      color: Colors.white.withOpacity(.4),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          // primary: false,
                          itemCount: users.length,
                          // itemCount: 3,
                          itemBuilder: (context, index) {
                            if (editingController.text.isEmpty) {
                              return new Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.5)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 25.0,
                                                    backgroundImage:
                                                        ExactAssetImage(
                                                            'assets/images/logo_circle.png'),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              users[index]
                                                                  .posted_by,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 17.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              '' +
                                                                  users[index]
                                                                      .time_ago,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                        /*  SizedBox(
                                                    height: 5.0,
                                                  ),

                                                  */ /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/ /*
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),*/
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //  Divider(color: Colors.grey,),
                                      Container(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /* Container(
                                        //  padding: EdgeInsets.all(15),
                                        padding: EdgeInsets.only(
                                            left: 7, right: 7, bottom: 4),
                                        child: Text(users[index].job,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 10,
                                            style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 7, right: 7, bottom: 4),
                                        child: Text(
                                            'location : ' + users[index].location,
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
                                            left: 7, right: 7, bottom: 4),
                                        child: Text(
                                            'Experience : ' +
                                                users[index].experience,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 7, right: 7, bottom: 4),
                                        child: Text(
                                            'Technology : ' +
                                                users[index].technology,
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
                                            left: 7, right: 7, bottom: 4),
                                        child: Text(
                                            'Job type : ' + users[index].job_type,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 10,
                                            style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 7, right: 7, bottom: 5),
                                        child: Text(
                                            'Date : ' + users[index].walkin_date,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 10,
                                            style: new TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            )),
                                      ),*/
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 2,
                                                    right: 7,
                                                    bottom: 0),
                                                child:
                                                    new DescriptionTextWidget(
                                                        text: users[index].job),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "Click event on Container");
                                                  launch(
                                                      "mailto:jyotigame@gmail.com?subject=&body=");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 8,
                                                      right: 7,
                                                      bottom: 5),
                                                  child: new Text(
                                                      "jyotigame@gmail.com",
                                                      style: new TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.blue,
                                                      )),
                                                ),
                                              ),
/*                                      InkWell(
                                        // mar: EdgeInsets.only(left: 15, right: 7, bottom: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Text(' See more',
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: MyColor.colorprimary,
                                              )),
                                        ),
                                        onTap: () {
                                         */ /* print('aaa1 $users[index].jobId');*/ /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => JobDetailsScreen(users[index].id)),
                              );
                                        },
                                      ),*/
                                            ],
                                          ),
                                        ),
                                      ),
                                      /* Divider(
                    color: Colors.blueGrey,
                  ),*/
                                      /* Container(
                                    width: double.infinity,
                                    height: 185,
                                    child: Image.asset(
                                        'assets/images/business.jpg')),*/
                                      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      users[index].job_img_path == ""
                                          ? Container(
                                              width: double.infinity,
                                              height: 1,
                                            )
                                          : users[index].job_img_path == null
                                              ? Container(
                                                  width: double.infinity,
                                                  height: 1,
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  height: 185,
                                                  child:
                                                      /*Image.asset(
                                        'assets/images/business.jpg')*/
                                                      new Image.network(
                                                    users[index].job_img_path,
                                                  )),

                                      ///////////////////////////////////////////////////////////////////////////////////////
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 10,
                                          right: 40,
                                          // bottom: 10
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.thumb_up,
                                              color: MyColor.colorprimary,
                                              size: 17,
                                            ),
                                            Text(
                                              " " + users[index].like_count,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Divider(
                                            color: Colors.grey,
                                          )),
                                      Container(
                                        //padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 1.0,
                                            ),
                                            /*Icon(Icons.thumb_up_alt_outlined),*/
                                            IconButton(
                                              /* icon: Icon(Icons.thumb_up,color: _like_iconColor),*/
                                              icon: Icon(Icons.thumb_up,
                                                  color:
                                                      users[index].is_liked ==
                                                              "yes"
                                                          ? MyColor.colorprimary
                                                          : Colors.grey),
                                              onPressed: () {
                                                // do something
                                                setState(() {
                                                  _getUusers();
                                                });
                                                apiAddLikes(
                                                    userId, users[index].id);
                                              },
                                            ),
                                            SizedBox(
                                              width: 18.0,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.favorite,
                                                  color: users[index]
                                                              .is_favourite ==
                                                          "yes"
                                                      ? Colors.red
                                                      : Colors.grey),
                                              onPressed: () {
                                                // do something
                                                setState(() {
                                                  //   _fav_iconColor = Colors.red;
                                                  _getUusers();
                                                });
                                                apiAddFavourite(
                                                    userId, users[index].id);
                                              },
                                            ),
                                            SizedBox(
                                              width: 18.0,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.share),
                                              onPressed: () {
                                                // do something
                                                Share.share(
                                                    users[index].job_link,
                                                    /* 'Posted By : ' +
                                                users[index].posted_by +
                                                ' , ' +
                                                '10 min ago' +
                                                ' , ' +
                                                'Description : ' +
                                                users[index].job +
                                                ' , ' +
                                                'Location : ' +
                                                users[index].location +
                                                ' , ' +
                                                'Experience : ' +
                                                users[index].experience +
                                                ' , ' +
                                                'Technology : ' +
                                                users[index].technology +
                                                ' , ' +
                                                'Job Type : ' +
                                                users[index].job_type +
                                                ' , ' +
                                                'Date : ' +
                                                users[index].walkin_date +
                                                ' . '*/
                                                    subject: 'Job Details');
                                              },
                                            ),
                                            SizedBox(
                                              width: 1.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            } else if (users[index].job.toLowerCase().contains(
                                    editingController.text.toLowerCase()) ||
                                users[index].location.toLowerCase().contains(
                                    editingController.text.toLowerCase()) ||
                                users[index].technology.toLowerCase().contains(
                                    editingController.text.toLowerCase())) {
                              return new Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.5)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(12.0),
                                              child: Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 25.0,
                                                    backgroundImage:
                                                        ExactAssetImage(
                                                            'assets/images/logo_circle.png'),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              users[index]
                                                                  .posted_by,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 17.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              '' +
                                                                  users[index]
                                                                      .time_ago,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                        /*  SizedBox(
                                                    height: 5.0,
                                                  ),

                                                  */ /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/ /*
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),*/
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //  Divider(color: Colors.grey,),
                                      Container(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 2,
                                                  right: 7,
                                                ),
                                                child:
                                                    new DescriptionTextWidget(
                                                        text: users[index].job),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "Click event on Container");
                                                  launch(
                                                      "mailto:jyotigame@gmail.com?subject=&body=");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 8,
                                                      right: 7,
                                                      bottom: 5),
                                                  child: new Text(
                                                      "jyotigame@gmail.com",
                                                      style: new TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Colors.blue,
                                                      )),
                                                ),
                                              ),
                                              /* print('aaa1 $users[index].jobId');*/ /*
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => JobDetailsScreen(users[index].id)),
                                            );
                                          },
                                        ),*/
                                            ],
                                          ),
                                        ),
                                      ),
                                      /* Divider(
                    color: Colors.blueGrey,
                  ),*/
                                      //////////////////////////////////////////////////////////////////
                                      users[index].job_img_path == ""
                                          ? Container(
                                              width: double.infinity,
                                              height: 1,
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 185,
                                              child:
                                                  /* Image.asset(
                                        'assets/images/business.jpg')*/
                                                  new Image.network(
                                                users[index].job_img_path,
                                              )),
                                      ////////////////////////////////////////////////
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 10,
                                          right: 40,
                                          // bottom: 10
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.thumb_up,
                                              color: MyColor.colorprimary,
                                              size: 17,
                                            ),
                                            Text(
                                              " " + users[index].like_count,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Divider(
                                            color: Colors.grey,
                                          )),
                                      Container(
                                        //padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 1.0,
                                            ),
                                            /*Icon(Icons.thumb_up_alt_outlined),*/
                                            IconButton(
                                              /* icon: Icon(Icons.thumb_up,color: _like_iconColor),*/
                                              icon: Icon(Icons.thumb_up,
                                                  color:
                                                      users[index].is_liked ==
                                                              "yes"
                                                          ? MyColor.colorprimary
                                                          : Colors.grey),
                                              onPressed: () {
                                                // do something
                                                setState(() {
                                                  _getUusers();
                                                });
                                                apiAddLikes(
                                                    userId, users[index].id);
                                              },
                                            ),
                                            SizedBox(
                                              width: 18.0,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.favorite,
                                                  color: users[index]
                                                              .is_favourite ==
                                                          "yes"
                                                      ? Colors.red
                                                      : Colors.grey),
                                              onPressed: () {
                                                // do something
                                                setState(() {
                                                  //   _fav_iconColor = Colors.red;
                                                  _getUusers();
                                                });
                                                apiAddFavourite(
                                                    userId, users[index].id);
                                              },
                                            ),
                                            SizedBox(
                                              width: 18.0,
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.share),
                                              onPressed: () {
                                                // do something
                                                Share.share(
                                                    users[index].job_link,
                                                    subject: 'Job Details');

/*
                                          Share.share(
                                              'Posted By : ' +
                                                  users[index].posted_by +
                                                  ' , ' +
                                                  '10 min ago' +
                                                  ' , ' +
                                                  'Description : ' +
                                                  users[index].job +
                                                  ' , ' +
                                                  'Location : ' +
                                                  users[index].location +
                                                  ' , ' +
                                                  'Experience : ' +
                                                  users[index].experience +
                                                  ' , ' +
                                                  'Technology : ' +
                                                  users[index].technology +
                                                  ' , ' +
                                                  'Job Type : ' +
                                                  users[index].job_type +
                                                  ' , ' +
                                                  'Date : ' +
                                                  users[index].walkin_date +
                                                  ' . ',
                                              subject: 'Job Details');
*/
                                              },
                                            ),
                                            SizedBox(
                                              width: 1.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            }
                            /*      else if (
                      users[index]
                          .job
                          .toLowerCase()
                          .contains(editingController.text.toLowerCase()) )

                      {
                        return new Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: ExactAssetImage(
                                                  'assets/images/logo_circle.png'),
                                              backgroundColor: Colors.white,
                                            ),
                                            Container(
                                              margin:
                                              EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        users[index].posted_by,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        '' +
                                                            users[index]
                                                                .time_ago,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),

                                                  */ /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/ /*
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //  Divider(color: Colors.grey,),
                                Container(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 2, right: 7, bottom: 5),
                                          child: new DescriptionTextWidget(
                                              text: users[index].job),
                                        ),
                                        */ /* print('aaa1 $users[index].jobId');*/ /* */ /*
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => JobDetailsScreen(users[index].id)),
                                            );
                                          },
                                        ),*/ /*
                                      ],
                                    ),
                                  ),
                                ),
                                */ /* Divider(
                    color: Colors.blueGrey,
                  ),*/ /*
                                Container(
                                    width: double.infinity,
                                    height: 185,
                                    child: Image.asset(
                                        'assets/images/business.jpg')),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                    right: 40,
                                    // bottom: 10
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.thumb_up,
                                        color: MyColor.colorprimary,
                                        size: 17,
                                      ),
                                      Text(
                                        " " + users[index].like_count,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Divider(
                                      color: Colors.grey,
                                    )),
                                Container(
                                  //padding: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                      */ /*Icon(Icons.thumb_up_alt_outlined),*/ /*
                                      IconButton(
                                        */ /* icon: Icon(Icons.thumb_up,color: _like_iconColor),*/ /*
                                        icon: Icon(Icons.thumb_up,
                                            color:
                                            users[index].is_liked == "yes"
                                                ? MyColor.colorprimary
                                                : Colors.grey),
                                        onPressed: () {
                                          // do something
                                          setState(() {
                                            _getUusers();
                                          });
                                          apiAddLikes(userId, users[index].id);
                                        },
                                      ),
                                      SizedBox(
                                        width: 18.0,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite,
                                            color: users[index].is_favourite ==
                                                "yes"
                                                ? Colors.red
                                                : Colors.grey),
                                        onPressed: () {
                                          // do something
                                          setState(() {
                                            //   _fav_iconColor = Colors.red;
                                            _getUusers();
                                          });
                                          apiAddFavourite(
                                              userId, users[index].id);
                                        },
                                      ),
                                      SizedBox(
                                        width: 18.0,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.share),
                                        onPressed: () {
                                          // do something
                                          Share.share(users[index].job_link,
                                              subject: 'Job Details');

*/ /*
                                          Share.share(
                                              'Posted By : ' +
                                                  users[index].posted_by +
                                                  ' , ' +
                                                  '10 min ago' +
                                                  ' , ' +
                                                  'Description : ' +
                                                  users[index].job +
                                                  ' , ' +
                                                  'Location : ' +
                                                  users[index].location +
                                                  ' , ' +
                                                  'Experience : ' +
                                                  users[index].experience +
                                                  ' , ' +
                                                  'Technology : ' +
                                                  users[index].technology +
                                                  ' , ' +
                                                  'Job Type : ' +
                                                  users[index].job_type +
                                                  ' , ' +
                                                  'Date : ' +
                                                  users[index].walkin_date +
                                                  ' . ',
                                              subject: 'Job Details');
*/ /*
                                        },
                                      ),
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      }*/

                            /*  else if (
                      */ /*  users[index]
                              .job
                              .toLowerCase()
                              .contains(editingController.text.toLowerCase()) ||*/ /*
                      users[index]
                          .job
                          .toLowerCase()
                          .contains(editingController.text.toLowerCase()) //||
                      */ /*  users[index]
                              .technology
                              .toLowerCase()
                              .contains(editingController.text.toLowerCase())*/ /*)
                      {
                        return new Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: ExactAssetImage(
                                                  'assets/images/logo_circle.png'),
                                              backgroundColor: Colors.white,
                                            ),
                                            Container(
                                              margin:
                                              EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        users[index].posted_by,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        '' +
                                                            users[index]
                                                                .time_ago,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),

                                                  */ /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/ /*
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //  Divider(color: Colors.grey,),
                                Container(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 2, right: 7, bottom: 5),
                                          child: new DescriptionTextWidget(
                                              text: users[index].job),
                                        ),
                                        */ /* print('aaa1 $users[index].jobId');*/ /* */ /*
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => JobDetailsScreen(users[index].id)),
                                            );
                                          },
                                        ),*/ /*
                                      ],
                                    ),
                                  ),
                                ),
                                */ /* Divider(
                    color: Colors.blueGrey,
                  ),*/ /*
                                Container(
                                    width: double.infinity,
                                    height: 185,
                                    child: Image.asset('assets/images/business.jpg')),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                    right: 40,
                                    // bottom: 10
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.thumb_up,
                                        color: MyColor.colorprimary,
                                        size: 17,
                                      ),
                                      Text(
                                        " " + users[index].like_count,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Divider(
                                      color: Colors.grey,
                                    )),
                                Container(
                                  //padding: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                      */ /*Icon(Icons.thumb_up_alt_outlined),*/ /*
                                      IconButton(
                                        */ /* icon: Icon(Icons.thumb_up,color: _like_iconColor),*/ /*
                                        icon: Icon(Icons.thumb_up,
                                            color:
                                            users[index].is_liked == "yes"
                                                ? MyColor.colorprimary
                                                : Colors.grey),
                                        onPressed: () {
                                          // do something
                                          setState(() {
                                            _getUusers();
                                          });
                                          apiAddLikes(userId, users[index].id);
                                        },
                                      ),
                                      SizedBox(
                                        width: 18.0,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.favorite,
                                            color: users[index].is_favourite ==
                                                "yes"
                                                ? Colors.red
                                                : Colors.grey),
                                        onPressed: () {
                                          // do something
                                          setState(() {
                                            //   _fav_iconColor = Colors.red;
                                            _getUusers();
                                          });
                                          apiAddFavourite(
                                              userId, users[index].id);
                                        },
                                      ),
                                      SizedBox(
                                        width: 18.0,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.share),
                                        onPressed: () {
                                          // do something
                                          Share.share(users[index].job_link,
                                              subject: 'Job Details');

*/ /*
                                          Share.share(
                                              'Posted By : ' +
                                                  users[index].posted_by +
                                                  ' , ' +
                                                  '10 min ago' +
                                                  ' , ' +
                                                  'Description : ' +
                                                  users[index].job +
                                                  ' , ' +
                                                  'Location : ' +
                                                  users[index].location +
                                                  ' , ' +
                                                  'Experience : ' +
                                                  users[index].experience +
                                                  ' , ' +
                                                  'Technology : ' +
                                                  users[index].technology +
                                                  ' , ' +
                                                  'Job Type : ' +
                                                  users[index].job_type +
                                                  ' , ' +
                                                  'Date : ' +
                                                  users[index].walkin_date +
                                                  ' . ',
                                              subject: 'Job Details');
*/ /*
                                        },
                                      ),
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      }*/
                            else {
                              return Container(
                                  /*child:Align(
                          alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                          child: Text("No Data Available."),
                        ),*/
                                  );
                            }
                          }),
                    ),
            ],
          ),
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
        title: Text(user.technology),
      ),
      body: Container(
        child: Text(user.technology),
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
      print('responce $data');
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
        isLoading = false;
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
  String walkin_date, location;
  String experience,
      technology,
      job,
      job_type,
      post_type,
      posted_by,
      is_favourite,
      is_liked,
      like_count,
      time_ago,
      job_img_path,
      job_link;

  User(
      {this.id,
      this.walkin_date,
      this.location,
      this.experience,
      this.technology,
      this.job,
      this.job_type,
      this.post_type,
      this.is_favourite,
      this.is_liked,
      this.posted_by,
      this.like_count,
      this.time_ago,
      this.job_img_path,
      this.job_link});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walkin_date = json['walkin_date'];
    location = json['location'];
    experience = json['experience'];
    technology = json['technology'];
    job = json['job'];
    job_type = json['job_type'];
    post_type = json['post_type'];
    is_favourite = json['is_favourite'];
    is_liked = json['is_liked'];
    posted_by = json['posted_by'];
    like_count = json['like_count'];
    time_ago = json['time_ago'];
    job_link = json['job_link'];
    job_img_path = json['job_img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['walkin_date'] = this.walkin_date;
    data['location'] = this.location;
    data['experience'] = this.experience;
    data['technology'] = this.technology;
    data['job'] = this.job;
    data['job_type'] = this.job_type;
    data['post_type'] = this.post_type;
    data['is_favourite'] = this.is_favourite;
    data['is_liked'] = this.is_liked;
    data['posted_by'] = this.posted_by;
    data['like_count'] = this.like_count;
    data['time_ago'] = this.time_ago;
    data['job_link'] = this.job_link;
    data['job_img_path'] = this.job_img_path;
    return data;
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 150) {
      firstHalf = widget.text.substring(0, 150);
      secondHalf = widget.text.substring(150, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf)
          : new Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                        flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        )),
                  ),
                ),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(flag ? "See more" : "See less",
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: MyColor.colorprimary,
                          )),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

/*class _DescriptionTextWidgetState extends State<DescriptionTextWidget>
{
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 60) {
      firstHalf = widget.text.substring(0, 60);
      secondHalf = widget.text.substring(60, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf)
          : new Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                        flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        )),
                  ),
                ),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(flag ? "See more" : "See less",
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: MyColor.colorprimary,
                          )),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}*/
