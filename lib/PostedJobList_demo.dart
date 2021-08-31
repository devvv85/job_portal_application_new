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

List<String> isChecked = [];
String struserType = "";
String s = "yes";
String strSrotby, strLoc,userId;
SharedPreferences prefs;
class PostedJob1 extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();

  PostedJob1(String sortby, String location)
  {
    strSrotby = sortby;
    strLoc = location;
  }
}
class _MyHomePageState extends State<PostedJob1>
{
  List<User> users = new List<User>();
  Color _like_iconColor = Colors.grey;
  Color _fav_iconColor = Colors.grey;
  TextEditingController editingController = TextEditingController();
  @override
  void initState()
  {
    setState(()
    {
      initializeSF();

    });
  }
  initializeSF() async
  {
    prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("uId");
    print('Posted job $userId');
    _getUusers();
  }

  Future<Album> _getUusers() async {

    Map data = {"sort": strSrotby, "loc_id": strLoc,"user_id":userId};
    print('para $data');
    final response = await http.post(uidata.JobLists, body: data);
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
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

      print(jsonData);
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
  Widget build(BuildContext context)
  {
    return new Scaffold(
      body: Container(
        color: MyColor.orange12,
        child: Column(
          children: <Widget>[
            Container(
             // margin: const EdgeInsets.only(bottom:8),
             // color: Colors.pink,
            child:Container(
              color: Colors.white,
              height: 45,
              margin: const EdgeInsets.only(left: 2,right: 2),
              child: TextField(
                onChanged: (value) {setState(() {});},
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              ),
            ),),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  // primary: false,
                  itemCount: users.length,
                  itemBuilder: (context, index)
                  {
                    if (editingController.text.isEmpty)
                    {
                      return new Card(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          color: Theme
                              .of(context)
                              .cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0.5)),
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
                                      margin: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: ExactAssetImage('assets/images/logo_circle.png'),
                                            backgroundColor: Colors.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.7,
                                                  child: Text(
                                                      users[index].posted_by,
                                                      overflow:
                                                      TextOverflow.ellipsis,
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
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width *
                                                      0.7,
                                                  child: Text(''+users[index].time_ago,
                                                      overflow:
                                                      TextOverflow.ellipsis,
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

                                                /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
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
                                      ),
                                      InkWell(
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
                                                color: Colors.blue,
                                              )),
                                        ),
                                        onTap: () {
                                         /* print('aaa1 $users[index].jobId');*/
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => JobDetailsScreen(users[index].id)),
                              );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /* Divider(
                    color: Colors.blueGrey,
                  ),*/
                              Container(
                                  width: double.infinity,
                                  height: 185,
                                  child:
                                  Image.asset('assets/images/business.jpg')),


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
                                      color: Colors.blue,
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
                                  margin:
                                  const EdgeInsets.only(left: 10.0, right: 10.0),
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
                                          color: users[index].is_liked == "yes"
                                              ? Colors.blue
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
                                          color:
                                          users[index].is_favourite == "yes"
                                              ? Colors.red
                                              : Colors.grey),
                                      onPressed: () {
                                        // do something
                                        setState(() {
                                          //   _fav_iconColor = Colors.red;
                                          _getUusers();
                                        });
                                        apiAddFavourite(userId, users[index].id);
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

                    else if (users[index]
                        .technology
                        .toLowerCase()
                        .contains(editingController.text) ||
                        users[index]
                            .technology
                            .toLowerCase()
                            .contains(editingController.text))
                    {
                      {
                        return new Card(
                            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            color: Theme
                                .of(context)
                                .cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0.5)),
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
                                              backgroundImage: ExactAssetImage('assets/images/logo_circle.png'),
                                              backgroundColor: Colors.white,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        users[index].posted_by,
                                                        overflow:
                                                        TextOverflow.ellipsis,
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
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(''+users[index].time_ago,
                                                        overflow:
                                                        TextOverflow.ellipsis,
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

                                                  /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
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
                                        ),
                                        InkWell(
                                          // mar: EdgeInsets.only(left: 15, right: 7, bottom: 5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Text(' See more',
                                                textAlign: TextAlign.right,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                )),
                                          ),
                                          onTap: () {
                                            /* print('aaa1 $users[index].jobId');*/
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => JobDetailsScreen(users[index].id)),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                /* Divider(
                    color: Colors.blueGrey,
                  ),*/
                                Container(
                                    width: double.infinity,
                                    height: 185,
                                    child:
                                    Image.asset('assets/images/business.jpg')),


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
                                        color: Colors.blue,
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
                                    margin:
                                    const EdgeInsets.only(left: 10.0, right: 10.0),
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
                                            color: users[index].is_liked == "yes"
                                                ? Colors.blue
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
                                            color:
                                            users[index].is_favourite == "yes"
                                                ? Colors.red
                                                : Colors.grey),
                                        onPressed: () {
                                          // do something
                                          setState(() {
                                            //   _fav_iconColor = Colors.red;
                                            _getUusers();
                                          });
                                          apiAddFavourite(userId, users[index].id);
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
                    }
                    else {
                      return Container();
                    }
                  }),
            ),
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
      is_liked,like_count,time_ago;

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
      this.like_count,time_ago});

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
    like_count=json['like_count'];
    time_ago=json['time_ago'];
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
    data['like_count']=this.like_count;
    data['time_ago']=this.time_ago;
    return data;
  }
}
