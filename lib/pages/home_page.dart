import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  List _imageUrls = [
//    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
//    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
//    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
//  ];
  double appBarAlpha = 0;
  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    this._handleRefresh();
//    this.loadData();
  }

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

//  loadData() {
//    HomeDao.fetch().then((result) {
//      setState(() {
//        resultString = json.encode(result.config);
//      });
//    }).catchError((e) {
//      setState(() {
//        resultString = json.encode(e);
//      });
//    });

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        // resultString = json.encode(model.config);
        _loading = false;
      });
    } catch(e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  Widget get _banner {
    return new Container(
      height: 160,
      child: new Swiper(
        itemCount: this.bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                CommonModel model = bannerList[index];
                return new Webview(
                  url: model.url,
                  title: model.title,
                  hideAppBar: model.hideAppBar,
                );
              }));
            },
            child: new Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: new SwiperPagination(),
      ),
    );
  }

  Widget get _listView {
    return new ListView(
      children: <Widget>[
        this._banner,
        new Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: new LocalNav(localNavList: localNavList),
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: new GridNav(gridNavModel: gridNavModel),
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: new SubNav(subNavList: subNavList),
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child: new SalesBox(salesBox: salesBoxModel),
        )
      ],
    );
  }

  Widget get _appBar {
    return new Opacity(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: new LoadingContainer(
        isLoading: _loading,
        child: new Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              removeTop: true, // 移除listView组件默认padding
              context: context,
              child: new RefreshIndicator(
                child: new NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                        this._onScroll(scrollNotification.metrics.pixels);
                      }
                    },
                    child: this._listView
                ),
                onRefresh: _handleRefresh
              )
            ),
            this._appBar
          ],
        )
      )
    );
  }

}