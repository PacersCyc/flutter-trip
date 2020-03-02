import 'package:flutter/material.dart';
import 'package:flutter_trip/plugin/asr_manager.dart';

import 'search_page.dart';

const double MIC_SIZE = 80;

class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => new _SpeakPageState();

}

class _SpeakPageState extends State<SpeakPage> with SingleTickerProviderStateMixin {
  String speakTips = "长按说话";
  String speakResult = '';
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );
    animation = new CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _speakStart() {
    controller.forward();
    setState(() {
      speakTips = "- 识别中 -";
    });
    AsrManager.start().then((text) {
      if(text != null && text.length > 0) {
        setState(() {
          speakResult = text;
        });
        Navigator.pop(context);
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new SearchPage(
          keyword: speakResult,
        )));
        print("------" + text);
      }
    }).catchError((e) {
      print("-------" + e);
    });
  }

  _speakStop() {
    setState(() {
      speakTips = '长按说话';
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }

  _topItem() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text(
            '你可以这样说',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54
            ),
          ),
        ),
        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey
          ),
        ),
        new Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            speakResult,
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }

  _bottomItem() {
    return new FractionallySizedBox(
      widthFactor: 1,
      child: new Stack(
        children: <Widget>[
          new GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakStop();
            },
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      speakTips,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12
                      ),
                    ),
                  ),
                  new Stack(
                    children: <Widget>[
                      new Container(
                        height: MIC_SIZE,
                        width: MIC_SIZE,
                      ),
                      new Center(
                        child: new AnimatedMic(
                          animation: animation,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          new Positioned(
            right: 0,
            bottom: 20,
            child: new GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: new Icon(
                Icons.close,
                size: 30,
                color: Colors.grey,
              ),
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _topItem(),
              _bottomItem()
            ],
          ),
        ),
      ),
    );
  }

}

class AnimatedMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimatedMic({Key key, Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: new Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(MIC_SIZE / 2)
        ),
        child: new Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

}