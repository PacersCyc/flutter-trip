import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => new _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = new PageController(
    initialPage: 0
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new PageView(
        controller: _controller,
        children: <Widget>[
          new HomePage(),
          new SearchPage(),
          new TravelPage(),
          new MyPage()
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home, color: this._defaultColor,),
              activeIcon: new Icon(Icons.home, color: this._activeColor),
              title: new Text(
                '首页',
                style: new TextStyle(
                    color: this._currentIndex != 0 ? this._defaultColor : this._activeColor
                ),
              )
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.search, color: this._defaultColor,),
              activeIcon: new Icon(Icons.search, color: this._activeColor),
              title: new Text(
                '搜索',
                style: new TextStyle(
                    color: this._currentIndex != 1 ? this._defaultColor : this._activeColor
                ),
              )
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.camera_alt, color: this._defaultColor,),
              activeIcon: new Icon(Icons.camera_alt, color: this._activeColor),
              title: new Text(
                '相机',
                style: new TextStyle(
                    color: this._currentIndex != 2 ? this._defaultColor : this._activeColor
                ),
              )
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle, color: this._defaultColor,),
              activeIcon: new Icon(Icons.account_circle, color: this._activeColor),
              title: new Text(
                '我的',
                style: new TextStyle(
                    color: this._currentIndex != 3 ? this._defaultColor : this._activeColor
                ),
              )
          )
        ],
        currentIndex: this._currentIndex,
        onTap: (index) {
          this._controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

}