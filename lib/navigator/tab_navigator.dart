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
          new SearchPage(
            hideLeft: true,
          ),
          new TravelPage(),
          new MyPage()
        ],
        physics: NeverScrollableScrollPhysics(), // 禁止底部tab滑动
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('搜索', Icons.search, 1),
          _bottomItem('相机', Icons.camera_alt, 2),
          _bottomItem('我的', Icons.account_circle, 3),
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

  _bottomItem(String title, IconData icon, int index) {
    return new BottomNavigationBarItem(
      icon: new Icon(icon, color: _defaultColor),
      activeIcon: new Icon(icon, color: _activeColor),
      title: Text(
        title,
        style: TextStyle(color: _currentIndex!=index?_defaultColor:_activeColor),
      )
    );
  }

}