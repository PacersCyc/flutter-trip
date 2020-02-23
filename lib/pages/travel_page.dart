import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => new _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('旅拍'),
      ),
    );
  }

}