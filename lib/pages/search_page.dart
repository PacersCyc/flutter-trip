import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/search_bar.dart';

const SEARCH_URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.searchUrl = SEARCH_URL, this.keyword, this.hint}) : super(key: key);

  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  _onTextChange(String text) {
    keyword = text;
    if (keyword.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + keyword;
    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _appBar() {
    return new Column(
      children: <Widget>[
        new Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: new Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: new SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        ),
      ],
    );
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) {
      return null;
    }
    SearchItem item = searchModel.data[position];
    return Text(item.word);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(),
      body: new Column(
        children: <Widget>[
          _appBar(),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: new Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: searchModel?.data?.length??0,
                itemBuilder: (BuildContext context, int position){
                  return _item(position);
                }
              )
            )
          )
        ],
      ),
    );
  }

}