import 'package:flutter/material.dart';

class ListViewDemoPage extends StatefulWidget {
  @override
  _ListViewDemoPageState createState() => _ListViewDemoPageState();
}

class _ListViewDemoPageState extends State<ListViewDemoPage> {
  var count = 10;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count + 1,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == count) {
      return Text('Loading');
    }
    return Text(index.toString());
  }
}
