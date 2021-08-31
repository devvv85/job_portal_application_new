import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_portal_application/Constants/uidata.dart';
import 'package:job_portal_application/DashboardScreens/FilterActivity.dart';
import 'package:job_portal_application/DashboardScreens/JobDetailsScreen.dart';
import 'package:job_portal_application/DashboardScreens/Notifications.dart';
import 'package:job_portal_application/DashboardScreens/PostedJobList.dart';
import 'package:job_portal_application/DashboardScreens/filters.dart';
import 'package:job_portal_application/Job%20Sharing/ChooseSkillActivity.dart';
import 'package:http/http.dart' as http;
import 'package:job_portal_application/MyColor.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'DashboardScreens/Favouritelist.dart';
import 'beer_list.dart';

List<User> users = new List<User>();
var name = "", email = "", location = "", skill = "", mob = "", userId;
String strSrotby, strLoc, strtechnology = "";
SharedPreferences prefs;
var tcVisibility = false;
var is_updated = "";
var _message;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

class DashboardActivity extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

  DashboardActivity(
      String sortby, String location, String uid, String technology) {
    strSrotby = sortby;
    strLoc = location;
    userId = uid;
    strtechnology = technology;
    print('DashBoard>>> $userId');
  }
}

class _MyHomePageState extends State<DashboardActivity> {
  //confirmation dialog
  List<User> users = new List<User>();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  //*********************************Notification*********************************************************/
  void firebaseCloudMessaging_Listeners() {
    print("bgghnghtghhgjyjn");
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //  if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');

      showNotification(message['data']['title'], message['data']['message']);
      setState(() => _message = message["data"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["data"]["title"]);
      showNotification(message['data']['title'], message['data']['message']);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["data"]["title"]);
      showNotification(message['data']['title'], message['data']['message']);
    });
  }

  /*Future onSelectNotification(String payload) async {}*/
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    // here set and put condition for property id
    var response = json.decode(payload) as Map;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardActivity("", "", "", "")),
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  //**************************************************************************************************
  @override
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  /*Navigator.of(context).pop(true),*/

                  setState(() {
                    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
                    googleSignIn.isSignedIn().then((s) {
                      googleSignIn.signOut();
                      //  Toast.show("signout", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    });
                  });
                  exit(0);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  int _selectedIndex = 0;
  var appBarTitleText = new Text(
    "Home",
    style: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: MyColor.colorprimary),
  );

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    PostedJob(strSrotby, strLoc, strtechnology, 1),
    NotificationList(),
    filters(),
    FavouriteList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        setState(() {
          strSrotby = " ";
          strLoc = " ";
          strtechnology = " ";
        });
        appBarTitleText = Text('Home',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColor.colorprimary,
            ));
      } else if (_selectedIndex == 1) {
        appBarTitleText = Text(
          'Notifications',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColor.colorprimary),
        );
      } else if (_selectedIndex == 2) {
        appBarTitleText = Text(
          'Preference',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColor.colorprimary),
        );
      } else {
        appBarTitleText = Text(
          'Favourite',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColor.colorprimary),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: Scaffold(
              body: Container(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              appBar: AppBar(
                title: appBarTitleText,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: MyColor.colorprimary),
                toolbarHeight: 37,
              ),
              drawer: Drawer(
                child: Container(
                  color: Colors.black87,
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    children: <Widget>[
/*                  UserAccountsDrawerHeader(
                    */ /*decoration: BoxDecoration(
                      color: Colors.black87,
                    ),*/ /*
                    accountName: */ /* Text(name),*/ /*
                        TextField(
                      controller: nameController,
                      autofocus: false,
                      decoration: InputDecoration.collapsed(
                        hintText: mob,
                        enabled: false,
                        border: InputBorder.none,
                        //fillColor: Colors.white
                      ),
                    ),
                    accountEmail: */ /*Text(skill),*/ /*
                        TextField(
                      controller: skillController,
                      autofocus: false,
                      decoration: InputDecoration.collapsed(
                        hintText: skillController.text,
                        enabled: false,
                        border: InputBorder.none,
                        //fillColor: Colors.white
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person),
                    ),
                    otherAccountsPictures: <Widget>[
                      */ /* CircleAvatar(
                    backgroundColor: Colors.blue,*/ /*

                      new IconButton(
                        icon: new Icon(Icons.close),
                        color: Colors.white,
                        highlightColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // ),
                    ],
                  ),*/
                      Container(
                        height: 20,
                      ),
                      ListTile(
                        title: Text(
                          "Your Details",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 2),
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.close),
                          color: Colors.white,
                          highlightColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      ListTile(
                        // leading: Icon(Icons.person_pin,size: 70,color: Colors.blue,),
                        /*leading: Image.asset(
                          'assets/images/person.png',
                          scale: 2.0,
                          height: 60.0,
                          width: 60.0,
                        ),*/
                        title: TextFormField(
                          controller: nameController,
                          autofocus: false,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 2),
                          decoration: InputDecoration.collapsed(
                            hintText: mob,
                            enabled: false,
                            border: InputBorder.none,
                            fillColor: Colors.white,
                          ),
                        ),
                        subtitle: TextFormField(
                          controller: skillController,
                          autofocus: false,
                          style: TextStyle(
                              color: Colors.white, fontSize: 17, height: 2),
                          decoration: InputDecoration.collapsed(
                            hintText: skillController.text,
                            enabled: false,
                            border: InputBorder.none,
                            //fillColor: Colors.white
                          ),
                        ),
                        /* trailing: new IconButton(
                          icon: new Icon(Icons.close),
                          color: Colors.white,
                          highlightColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),*/
                      ),
                      Container(
                        height: 30,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: MyColor.white,
                        ),
                        title: TextFormField(
                          controller: locationController,
                          autofocus: false,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: location,
                            enabled: false,
                            border: InputBorder.none,
                          ),
                        ),
                        trailing: Icon(
                          Icons.edit,
                          color: MyColor.white,
                        ),
                        onTap: () => {dialogUpdateLocation(context)},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.call,
                          color: MyColor.white,
                        ),
                        onTap: () => {dialogUpdateContact(context)},
                        title: TextFormField(
                          controller: contactController,
                          autofocus: false,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration.collapsed(
                            hintText: mob,
                            enabled: false,
                            border: InputBorder.none,
                          ),
                        ),
                        trailing: Icon(
                          Icons.edit,
                          color: MyColor.white,
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.email,
                          color: MyColor.white,
                        ),
                        onTap: () => {dialogUpdateEmail(context)},
/*                        title: TextField(
                          controller: emailController,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          autofocus: false,
                          style: TextStyle(color: Colors.white, fontSize: 16,),
                          decoration: InputDecoration.collapsed(
                            hintText: email,
                            enabled: false,

                            border: InputBorder.none,
                          ),
                        )*/
                        title: Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          // autofocus: false,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
/*                          decoration: InputDecoration.collapsed(
                            hintText: email,
                            enabled: false,

                            border: InputBorder.none,
                          ),*/
                        ),
                        trailing: Icon(
                          Icons.edit,
                          color: MyColor.white,
                        ),
                        /*  trailing: Icon(Icons.person),
                onTap: () => {},*/
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
            //   ),

            /* bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: MyColor.blackgradient,
              primaryColor: MyColor.blackgradient,
              textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: MyColor.blackgradient)),
            ),*/
            /*    bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black54,
              primaryColor:Colors.black54,
              textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Colors.black54,)),
            ),*/
            bottomNavigationBar: Container(
              height: 65,
              decoration: BoxDecoration(
                color: MyColor.transperent,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(1.0),
                    topLeft: Radius.circular(1.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(1.0),
                  topRight: Radius.circular(1.0),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.black54,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      // icon: Icon(Image.asset(choice.icon.image)),
                      icon: CircleAvatar(
                        radius: 16,
                        backgroundColor: MyColor.white,
                        child: IconButton(
                          icon: Icon(
                            Icons.home,
                            color: MyColor.colorprimary,
                            size: 17,
                          ),
                        ),
                      ),
                      title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                        icon: CircleAvatar(
                          radius: 16,
                          backgroundColor: MyColor.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: MyColor.colorprimary,
                              size: 17,
                            ),
                          ),
                        ),
                        // icon: Icon(Icons.notifications, size: 17,),
                        title: Text(
                          'Notifications',
                        )),
                    BottomNavigationBarItem(
                        /* icon: Icon(Icons.filter_alt_sharp,),*/
                        icon: CircleAvatar(
                          radius: 16,
                          backgroundColor: MyColor.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_alt_sharp,
                              color: MyColor.colorprimary,
                              size: 17,
                            ),
                          ),
                        ),
                        //  icon: Icon(Icons.filter_alt_sharp,),
                        title: Text(
                          'Filter',
                        )),
                    BottomNavigationBarItem(
                      icon: CircleAvatar(
                        radius: 16,
                        backgroundColor: MyColor.white,
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: MyColor.colorprimary,
                            size: 17,
                          ),
                        ),
                      ),
                      //icon: Icon(Icons.filter_alt_sharp,),
                      title: Text(
                        'Favourite',
                      ),
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: MyColor.colorprimary,
                  onTap: _onItemTapped,
                ),
              ),
            )));
  }

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    print("aaaa $userId");
    apiGetProfile();
    apiOneYearUpdate();
  }

  @override
  void initState() {
    super.initState();
    /*  WidgetsBinding.instance
        .addPostFrameCallback((_) => dialog_profileUpdate(context));*/
    setState(() {
      initializeSF();
      /*  apiGetProfile();
      apiOneYearUpdate();*/
      firebaseCloudMessaging_Listeners();
    });
  }

  dialog_profileUpdate(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        apiGetProfile();
                      });
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
/*                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Update"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
                                  },
                                ),
                              ),*/
                      Container(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/images/profile.png')),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Center(
                          child: Text(
                            'Update Your Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Center(
                          child: Text(
                            'You have Completed 1 year Please Update your Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        // height: 50,
                        padding: EdgeInsets.only(top: 4),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: MyColor.colorprimary,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(2)),
                          child: Text(
                            "        Update        ",
                            style: TextStyle(
                                fontSize: 17, color: MyColor.colorprimary),
                          ),
                          onPressed: () {
                            setState(() {
                              apiGetProfile();
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseSkillActivity('')),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: MyColor.colorprimary,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(2)),
                          child: Text(
                            "Remind me Later",
                            style: TextStyle(
                                fontSize: 17, color: MyColor.colorprimary),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate())
                            {
                              _formKey.currentState.save();
                              Navigator.of(context).pop();
                            }
                            setState(()
                            {
                              apiGetProfile();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

//*****************profile api call *********************//
  apiGetProfile() async {
    Map data = {"id": userId};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.Profile, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print(jsonData);
      if (status == "1") {
        setState(() {
          name = jsonData['name'];
          email = jsonData['email'];
          location = jsonData['location'];
          skill = jsonData['skills'];
          mob = jsonData['mobile'];
          locationController.text = location;
          contactController.text = mob;
          emailController.text = email;
          nameController.text = name;
          skillController.text = skill;
        });

        if (location == null) {
          location = "";
        }
      } else {
        //  Toast.show(status, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  apiOneYearUpdate() async {
    print("idw>>$userId");
    Map data = {"id": userId};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.OneYearUpdate, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      is_updated = jsonData['is_updated'];
      //  is_updated="no";
      print(jsonData);

      if (is_updated == "yes") {
        // Toast.show(is_updated, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => dialog_profileUpdate(context));
      }
    } else {}
  }

  //******************************//
  TextEditingController _textFieldemailController = TextEditingController();
  TextEditingController _textFieldlocController = TextEditingController();
  TextEditingController _textFieldcontactController = TextEditingController();

  Future<void> dialogUpdateEmail(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: TextField(
            controller: _textFieldemailController,
            decoration: InputDecoration(hintText: "Enter email id"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: ()
              {
                if(_textFieldemailController.text.toString().isNotEmpty)
                  {
                    print(_textFieldemailController.text);
                    apiUpdateProf("", "", _textFieldemailController.text, userId);
                    Navigator.pop(context);
                  }
                else
                  {
                    Toast.show("Please enter Email id !!", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }

              },
            ),
          ],
        );
      },
    );
  }

//*****************************************Update location************************************************************************************//
  Future<void> dialogUpdateContact(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: TextField(
            controller: _textFieldcontactController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter Contact no"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                if(_textFieldcontactController.text.toString().isNotEmpty)
                {
                  print(_textFieldcontactController.text);
                  apiUpdateProf(
                      "", _textFieldcontactController.text, "", userId);
                  Navigator.pop(context);
                }
                else
                {
                  Toast.show("Please enter Contact no. !!", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }
              },
            ),
          ],
        );
      },
    );
  }

//***************************************************************************************************************************//
  Future<void> dialogUpdateLocation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: TextField(
            controller: _textFieldlocController,
            decoration: InputDecoration(hintText: "Enter location"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                if(_textFieldlocController.text.toString().isNotEmpty)
                {
                  print(_textFieldlocController.text);
                  apiUpdateProf(_textFieldlocController.text, "", "", userId);
                  Navigator.pop(context);
                }
                else
                {
                  Toast.show("Please enter Location !!", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }

              },
            ),
          ],
        );
      },
    );
  }

//*********api call***********//
  /// update profile

  apiUpdateProf(
      String location, String contact, String emailid, String uId) async {
    Map data = {
      "id": uId,
      "loc": location,
      "mail": emailid,
      "mno": contact,
    };
    print("parameter>>$data");
    var jsonData = null;
    var response = await http.post(uidata.ProfileEdit, body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print("prof update res>>$jsonData");
      apiGetProfile();
      var status = jsonData['status'];
      var msg = jsonData['message'];
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          apiGetProfile();
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
//***************************//
}

/////////filter ////////
class Fil extends StatelessWidget {
  const Fil({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5DDD5),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Container(
              height: 58,
              padding: EdgeInsets.all(7),
              margin: const EdgeInsets.only(top: 2.0, bottom: 3),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(children: [
                        Container(
                          height: 110.0,
                          child: FlutterLogo(
                            size: 50.0,
                          ),
                        ),
                        Container(
                          height: 110.0,
                          child: FlutterLogo(
                            size: 50.0,
                          ),
                        ),
                        Container(
                          height: 110.0,
                          child: FlutterLogo(
                            size: 50.0,
                          ),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white60,
                      ),
                    ),
                  ]),
            ),
            Container(
                /* padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),*/
                padding: EdgeInsets.all(2),
                height: 48,
                margin: const EdgeInsets.only(top: 15.0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: MyColor.colorprimary,
                  child: Text(
                    'Set Preferences',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Registration_Step1()),);
                  },
                ))
          ]),
        ));
  }
}

/////////filter ////////
class Favourite extends StatelessWidget {
  const Favourite({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(14),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 49,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
              ],
            )));
  }

  /*void initState()
  {
    print("init");

      apigetFavData();


  }*/
//
/*
  apigetFavData() async {
    Map data = {"id": "2"};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.Profile, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print(jsonData);
      if (status == "1")
      {
        print("in apiiiiiiiiiiiii>");
        name = jsonData['name'];
        email = jsonData['email'];
        location = jsonData['location'];
        */
/*skill=jsonData['location'];
    mob=jsonData['location'];*/ /*



      } else {
       */
/* Toast.show(status, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/ /*

      }
    } else {}
  }
*/

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    //throw UnimplementedError();
  }
}

///home page
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  void initState() {
    _getUusers();
  }

  Future<Album> _getUusers() async {
    final response = await http.get(uidata.chooseSkills);
    if (response.statusCode == 200) {
      print("responce");
      var res = Album.fromJson(jsonDecode(response.body));
      /* setState(() {*/
      users = res.data;
      userStatus.add(false);
      /* });*/
    } else {
      throw Exception('Failed to load skills');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(users[index].techName),
                onTap: () {},
              );
            }),
      ],
    )));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
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

class a extends State<DashboardActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: EdgeInsets.all(14),
            child: ListView(
              children: <Widget>[
                Container(
                    width: 160,
                    height: 125,
                    child: Image.asset('assets/images/logo.png')),
                Container(
                  height: 49,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),

                //  ),

                Container(
                    height: 65,
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
                        'Forgot  Password',
                        style: TextStyle(
                            fontSize: 17, color: MyColor.colorprimary),
                      ),
                      onPressed: () {},
                    )),

                Container(
                    child: Row(
                  children: <Widget>[
                    Text(
                      'Do not have an account?',
                      /*style: TextStyle(fontSize: 17),*/
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    FlatButton(
                      textColor: MyColor.colorprimary,
                      child: Text(
                        'REGISTER',
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        //signup screen
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}
