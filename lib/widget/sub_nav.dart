import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  _items(BuildContext context) {
    if (this.subNavList == null) {
      return null;
    }
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(this._item(context, model));
    });
    int separate = (subNavList.length / 2 + 0.5).toInt();
    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        new Padding(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate, subNavList.length),
          ),
          padding: EdgeInsets.only(top: 10),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return new Expanded(
      flex: 1,
      child: new GestureDetector(
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
              width: 18,
              height: 18,
            ),
            new Padding(
              padding: EdgeInsets.only(top: 3),
              child: new Text(
                model.title,
                style: new TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6)
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: this._items(context),
      ),
    );
  }

}