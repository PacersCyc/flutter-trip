import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];
  double appBarAlpha = 0;

  _onScroll(offset) {
    // print(offset);
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if(alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(appBarAlpha);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          MediaQuery.removePadding(
            removeTop: true, // 移除listView组件默认padding
            context: context,
            child: new NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                  this._onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: new ListView(
                children: <Widget>[
                  new Container(
                    height: 160,
                    child: new Swiper(
                      itemCount: this._imageUrls.length,
                      autoplay: true,
                      itemBuilder: (BuildContext context, int index) {
                        return new Image.network(
                          _imageUrls[index],
                          fit: BoxFit.fill,
                        );
                      },
                      pagination: new SwiperPagination(),
                    ),
                  ),
                  new Container(
                    height: 800,
                    child: new ListTile(
                        title: new Text('哈哈')
                    ),
                  )
                ],
              )
            )
          ),
          new Opacity(
            opacity: this.appBarAlpha,
            child: new Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: new Center(
                child: new Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: new Text('首页'),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

}