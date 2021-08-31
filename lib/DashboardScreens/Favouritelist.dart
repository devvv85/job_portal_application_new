import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';

import '../DashboardActivity.dart';
import '../MyColor.dart';
import 'JobDetailsScreen.dart';

List<String> isChecked = [];
String struserType = "", userId = "";
SharedPreferences prefs;
bool isvalid=false;
//var len=0;
class FavouriteList extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FavouriteList> {
  List<User> users = new List<User>();
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
    print('favouritelist $userId');
    isvalid=false;
    apifavcount(userId,isvalid);
    /* _getUusers();*/
  }

  Future<Album> _getUusers() async {
    Map data = {"id": userId};
    print('data>> $data');
    final response = await http.post(uidata.FavouriteLists, body: data);

    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      if (res != null) {
        print('Res $res');
        setState(() {
          users = res.date;
        });
      } else {
        Toast.show("No data available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      throw Exception('Failed to load skills');
    }
  }

  //favourite list count
  apifavcount(String id,bool isvalid1) async {
    Map data = {
      "id": id,
    };
    print("favcount>>>>$data");
    var jsonData = null;
    var response = await http.post(uidata.FavCount, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var cnt = jsonData['count'];

      if (cnt == "0")
      {
        if(isvalid1==false)
          {
            Toast.show("No Data available in favourite list", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        else
          {
            isvalid1=false;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardActivity("","",userId,""),));

          }

      } else {
        _getUusers();
        //  Toast.show("great", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
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


  /// Add to favourite
  apiAddFavourite(String id, String j_id) async {
    print('parafff $j_id');
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
      var is_favourite = jsonData['is_favourite'];
      print('Resfav $jsonData');
      if (status == "1")
      {
        setState(() {
          isvalid=true;
          apifavcount(userId,isvalid);
        });
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);


      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        setState(() {
          isvalid=true;
          apifavcount(userId,isvalid);
        });
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardActivity("",""),));
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*  appBar: new AppBar(
        title: new Text(''),
      ),*/
      body: Container(
        color: MyColor.orange12,
        child: Column(
          children: <Widget>[
            Container(
              // margin: const EdgeInsets.only(bottom:8),
              // color: Colors.pink,
              child: Container(
                color: Colors.white,
                height: 45,
                margin: const EdgeInsets.only(left: 2, right: 2,top: 5),
                /*   height: 43,
              margin: const EdgeInsets.only(bottom:5,left: 3,right: 3,top:5),*/
                child: TextField(
                  onChanged: (value)
                  {
                    setState(() {});
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                     // hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: editingController.text.isNotEmpty?IconButton(
                        onPressed: () { FocusScope.of(context).unfocus();editingController.clear();},
                        icon: Icon(Icons.clear),
                      ):null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  //   primary: false,
                  itemCount: users.length,
                  itemBuilder: (context, index)
                  {
                    if (editingController.text.isEmpty)
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
                                      margin: EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: ExactAssetImage(
                                                'assets/images/logo_circle.png'),
                                            backgroundColor: Colors.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                      users[index].posted_by==null ?"" :users[index].posted_by,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 5,
                                                      style: new TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      )),
                                                ),
                                                SizedBox(height: 5.0,),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                      '' +
                                                          users[index].time_ago,
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
                                    ],
                                  ),
                                ),
                              ),
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
                                  child:
                                      Divider(color: Colors.grey, height: 20)),
                              Container(
                                // padding: EdgeInsets.all(7.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 1.0,
                                    ),
                                    /*Icon(Icons.thumb_up_alt_outlined),*/
                                    IconButton(
                                      icon: Icon(Icons.thumb_up,
                                          color: users[index].is_liked == "yes"
                                              ? MyColor.colorprimary
                                              : Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _getUusers();
                                        });
                                       /* apiAddLikes(
                                            userId, users[index].job_id);*/
                                        setState(() async {
                                          Map data = {
                                            "id": userId,
                                            "j_id": users[index].job_id,
                                          };
                                          print(data);
                                          var jsonData = null;
                                          var response = await http.post(uidata.AddLikes, body: data);

                                          if (response.statusCode == 200) {
                                            jsonData = json.decode(response.body);
                                            var status = jsonData['staus'];
                                            var msg = jsonData['message'];
                                            setState(() {
                                             // likecount = jsonData['like_count'];
                                              users[index].like_count = jsonData['like_count'];;
                                            //  print("likecount$likecount$msg");

                                              if (msg ==
                                                  "Unliked") {
                                                users[index]
                                                    .is_liked =
                                                "no";
                                              } else {
                                                users[index]
                                                    .is_liked =
                                                "yes";
                                              }
                                            });

                                            print(jsonData);
                                            if (status == "1") {
                                              setState(() {
                                                _getUusers();
                                              });
                                              Toast.show(msg, context,
                                                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                            } else {
                                              Toast.show(msg, context,
                                                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                            }
                                          } else {}
                                        });
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
                                        // apiAddFavourite("1", users[index].id);

                                        apiAddFavourite(
                                            userId, users[index].job_id);
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
                                          users[index].link,
);
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
                    } else if (users[index]
                            .job
                            .toLowerCase()
                            .contains(editingController.text.toLowerCase()) ||
                        users[index]
                            .location
                            .toLowerCase()
                            .contains(editingController.text.toLowerCase())||
                        users[index]
                            .technology
                            .toLowerCase()
                            .contains(editingController.text.toLowerCase()))
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
                                      margin: EdgeInsets.all(5.0),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: ExactAssetImage(
                                                'assets/images/logo_circle.png'),
                                            backgroundColor: Colors.white,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                      '' +
                                                          users[index].time_ago,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 2, right: 7, bottom: 5),
                                        child: new DescriptionTextWidget(
                                            text: users[index].job,

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*  Divider(
                    color: Colors.blueGrey,
                  ),*/
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
                                  child:
                                      Divider(color: Colors.grey, height: 20)),
                              Container(
                                // padding: EdgeInsets.all(7.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 1.0,
                                    ),
                                    /*Icon(Icons.thumb_up_alt_outlined),*/
                                    IconButton(
                                      icon: Icon(Icons.thumb_up,
                                          color: users[index].is_liked == "yes"
                                              ? MyColor.colorprimary
                                              : Colors.grey),
                                      onPressed: () {

                                       // apiAddLikes(userId, users[index].job_id);
                                        setState(() async {
                                          Map data = {
                                          "id": userId,
                                          "j_id": users[index].job_id,
                                          };
                                          print(data);
                                          var jsonData = null;
                                          var response = await http.post(uidata.AddLikes, body: data);

                                          if (response.statusCode == 200) {
                                          jsonData = json.decode(response.body);
                                          var status = jsonData['staus'];
                                          var msg = jsonData['message'];
                                          setState(() {
                                            // likecount = jsonData['like_count'];
                                            users[index].like_count = jsonData['like_count'];;
                                            //  print("likecount$likecount$msg");

                                            if (msg ==
                                                "Unliked") {
                                              users[index]
                                                  .is_liked =
                                              "no";
                                            } else {
                                              users[index]
                                                  .is_liked =
                                              "yes";
                                            }
                                          });

                                          print(jsonData);
                                          if (status == "1") {
                                            setState(() {
                                              _getUusers();
                                            });
                                          Toast.show(msg, context,
                                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                          } else {
                                          Toast.show(msg, context,
                                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                          }
                                          } else {}
                                        });
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
                                        // apiAddFavourite("1", users[index].id);

                                        apiAddFavourite(
                                            userId, users[index].job_id);
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
                                            users[index].link,
                                            subject: 'Job Details');
                                      },
                                    ),
/*                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            'J',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),*/

                                    SizedBox(
                                      width: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    } else {
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
        title: Text(user.job),
        backgroundColor: MyColor.colorprimary,
      ),
      body: Container(
        child: Text(user.job),
      ),
    );
  }
}

class Album {
  String status;
  List<User> date;

  Album({this.status, this.date});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    print('resssss $status');
    if (status == "1") {
      if (json['date'] != null) {
        date = new List<User>();
        json['date'].forEach((v) {
          date.add(new User.fromJson(v));
          // userStatus.add(false);
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> date = new Map<String, dynamic>();
    date['status'] = this.status;
    if (this.date != null) {
      date['date'] = this.date.map((v) => v.toJson()).toList();
    }
    return date;
  }
}

class User {
  String id;
  String walkin_date;
  String posteddt;
  String location,
      experience,
      technology,
      job,
      job_type,
      post_type,
      is_favourite,
      is_liked,
      job_id,
      user_id,
      posted_by,
      like_count,
      time_ago,link;

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
      this.job_id,
      this.user_id,
      this.posted_by,
      this.like_count,
      this.time_ago,
      this.link});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walkin_date = json['walkin_date'];
    job = json['job'];
    job_type = json['job_type'];
    post_type = json['post_type'];
    is_favourite = json['is_favourite'];
    location = json['location'];
    experience = json['experience'];
    technology = json['technology'];
    is_liked = json['is_liked'];
    job_id = json['job_id'];
    user_id = json['user_id'];
    posted_by = json['posted_by'];
    like_count = json['like_count'];
    time_ago = json['time_ago'];
    link=json['job_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['walkin_date'] = this.walkin_date;
    data['job'] = this.job;
    data['job_type'] = this.job_type;
    data['post_type'] = this.post_type;
    data['is_favourite'] = this.is_favourite;
    data['is_liked'] = this.is_liked;
    data['job_id'] = this.job_id;
    data['user_id'] = this.user_id;
    data['posted_by'] = this.posted_by;
    data['location'] = this.location;
    data['experience'] = this.experience;
    data['technology'] = this.technology;
    data['like_count'] = this.like_count;
    data['time_ago'] = this.time_ago;
    data['job_link']=this.link;
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

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    }
    else
      {
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
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,

                    )),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(flag ? "See more" : "See less",
                          style: new TextStyle(
                            fontSize: 14,
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
