import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar({Key key, this.enabled = true, this.hideLeft, this.searchBarType = SearchBarType.normal, this.hint, this.defaultText, this.leftButtonClick, this.rightButtonClick, this.speakClick, this.inputBoxClick, this.onChanged}) : super(key: key);

  @override
  _SearchBarState createState() => new _SearchBarState();

}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();

  }

  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _wrapTap(Widget child, void Function() callback) {
    return new GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }

    return new Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(widget.searchBarType == SearchBarType.normal ? 5 : 15)
      ),
      child: new Row(
        children: <Widget>[
          new Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal ? Color(0xffa9a9a9) : Colors.blue,
          ),
          new Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
              ? new TextField(
                controller: _controller,
                onChanged: _onChanged,
                autofocus: true,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  textBaseline: TextBaseline.alphabetic
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5, -18, 5, 0),
                  border: InputBorder.none,
                  hintText: widget.hint??'',
                  hintStyle: TextStyle(fontSize: 15)
                ),
              )
              : this._wrapTap(
                new Container(
                  child: Text(
                    widget.defaultText,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ), 
                widget.inputBoxClick
              )
          ),
          !showClear
            ? this._wrapTap(
              new Icon(
                Icons.mic,
                size: 22,
                color: widget.searchBarType == SearchBarType.normal ? Colors.blue : Colors.grey,
              ),
              widget.speakClick
            )
            : this._wrapTap(
                new Icon(
                  Icons.clear,
                  size: 22,
                  color: Colors.grey,
                ),
                () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                }
              )
        ],
      ),
    );
  }

  _genNormalSearch() {
    return new Container(
      child: new Row(
        children: <Widget>[
          this._wrapTap(
            new Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft??false ? null : new Icon(Icons.arrow_back_ios, color: Colors.grey, size: 26),
            ),
            widget.leftButtonClick
          ),
          new Expanded(
            flex: 1,
            child: _inputBox()
          ),
          this._wrapTap(
            new Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(
                '搜索',
                style: TextStyle(color: Colors.blue, fontSize: 17),
              ),
            ),
            widget.rightButtonClick
          )
        ],
      ),
    );
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }

  _genHomeSearch() {
    return new Container(
      child: new Row(
        children: <Widget>[
          this._wrapTap(
            new Container(
              padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
              child: new Row(
                children: <Widget>[
                  Text(
                    '上海',
                    style: TextStyle(fontSize: 14, color: _homeFontColor()),
                  ),
                  new Icon(
                    Icons.expand_more,
                    color: _homeFontColor(),
                    size: 22,
                  )
                ],
              )
            ),
            widget.leftButtonClick
          ),
          new Expanded(
            flex: 1,
            child: _inputBox()
          ),
          this._wrapTap(
            new Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: new Icon(
                Icons.comment,
                color: _homeFontColor(),
                size: 26,
              )
            ),
            widget.rightButtonClick
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

}