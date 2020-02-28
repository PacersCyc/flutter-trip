import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = [
  'm.ctrip.com/',
  'm.ctrip.com/html5/',
  'm.ctrip.com/html5'
];

class Webview extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  const Webview({Key key, this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid = false}) : super(key: key);

  @override
  _WebviewState createState() => new _WebviewState();

}

class _WebviewState extends State<Webview> {
  final webviewReference = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value)??false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void initState() {
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url) {

    });
    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch(state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {
              webviewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
    super.dispose();
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar??false) {
      return new Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return new Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: new FractionallySizedBox(
        widthFactor: 1,
        child: new Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: new Container(
                margin: EdgeInsets.only(left: 10),
                child: new Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            new Positioned(
              left: 0,
              right: 0,
              child: new Center(
                child: new Text(
                  widget.title??'',
                  style: new TextStyle(
                    color: backButtonColor,
                    fontSize: 20
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String statusColorStr = widget.statusBarColor??'ffffff';
    Color backButtonColor;
    if (statusColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }


    return new Scaffold(
      body: new Column(
        children: <Widget>[
          _appBar(Color(int.parse('0x' + statusColorStr)), backButtonColor),
          new Expanded(
            child: new WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: new Container(
                color: Colors.white,
                child: new Center(
                  child: new Text('waiting...'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}