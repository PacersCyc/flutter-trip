import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({Key key, @required this.localNavList}) : super(key: key);

  _items(BuildContext context) {
    if (this.localNavList == null) {
      return null;
    }
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(this._item(context, model));
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new Webview(
            url: model.url,
            statusBarColor: model.statusBarColor,
            hideAppBar: model.hideAppBar,
          ))
        );
      },
      child: new Column(
        children: <Widget>[
          Image.network(
            model.icon,
            width: 32,
            height: 32,
          ),
          new Text(
            model.title,
            style: new TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 64,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: this._items(context),
      ),
    );
  }

}