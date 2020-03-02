import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/widget/search_bar.dart';

import '../widget/webview.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
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

  @override
  void initState() {
    if (widget.keyword != null) {
      _onTextChange(widget.keyword);
    }
    super.initState();
  }

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

  _jumpToSpeak() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new SpeakPage()));
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
              speakClick: _jumpToSpeak,
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

  _typeImage(String type) {
    if (type == null) {
      return "images/type_travelgroup.png";
    }

    String path = 'travelgroup';
    for(final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) {
      return spans;
    }

    List<String> arr = word.split(keyword);
    TextStyle normalTextStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );
    TextStyle keywordTextStyle = TextStyle(
      fontSize: 16,
      color: Colors.orange,
    );

    for(int i=0;i<arr.length;i++) {
      if ((i+1)%2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordTextStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalTextStyle));
      }
    }
    return spans;
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
      text: ' ' + (item.districtname??'') + ' ' + (item.zonename??''),
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey
      ),
    ));

    return new RichText(
      text: TextSpan(
        children: spans
      )
    );
  }

  _subTitle(SearchItem item) {
    return new RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: item.price??'',
            style: TextStyle(
              fontSize: 16,
              color: Colors.orange
            )
          ),
          TextSpan(
            text: ' ' + (item.star??''),
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey
            )
          ),
        ]
      )
    );
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) {
      return null;
    }
    SearchItem item = searchModel.data[position];
    return new GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new Webview(
          url: item.url,
          title: '详情',
        )));
      },
      child: new Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
        ),
        child: new Row(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.all(1),
              child: new Image(
                width: 26,
                height: 26,
                image: AssetImage(_typeImage(item.type))
              ),
            ),
            new Column(
              children: <Widget>[
                new Container(
                  width: 300,
                  child: _title(item),
                ),
                new Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
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