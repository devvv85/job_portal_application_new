import 'package:flutter/material.dart';
import 'package:job_portal_application/login/Login_Screen.dart';
import 'package:job_portal_application/login/Registration_Step1.dart';
import 'package:toast/toast.dart';

import '../MyColor.dart';

class FilterActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}
class _State extends State<FilterActivity>
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MyColor.colorprimary,
      ),
      home: Scaffold(
        backgroundColor: Color(0xffE5DDD5),
      //  appBar: AppBar(title: Text('Preference')),
        body: RowsAndColumns(),
      ),
    );
  }
}
class RowsAndColumns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5DDD5),
        body: Padding(
          padding: EdgeInsets.all(1),
          child: ListView(children: <Widget>[
            Container(
              height: 45,
             // padding: EdgeInsets.all(7),
              margin: const EdgeInsets.only(left:7.0,right: 7.0, bottom: 5.0),
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
                margin: const EdgeInsets.only(left:7.0,right: 7.0, bottom: 5.0,top: 5.0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: MyColor.colorprimary,
                  child: Text(
                    'Set Preferences',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: ()
                  {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Registration_Step1()),);
                  },
                ))
          ]),
        ));
  }
}
