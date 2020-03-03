import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

const PAGE_SIZE = 10;
const TRAVEL_URL = 'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final String groupChannelCode;

  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode}) : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();

}

class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _scrollController = new ScrollController();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) {
      return [];
    }
    List<TravelItem> filterItems = [];
    resultList.forEach((item){
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  void _loadData({ loadMore = false }) {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    TravelDao.fetch(widget.travelUrl??TRAVEL_URL, widget.groupChannelCode, pageIndex, PAGE_SIZE).then((TravelModel model){
      _loading = false;
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    }).catchError((e){
      _loading = false;
      print(e);
    });
  }

  Future<Null> _handleRefresh() async{
    _loadData();
    return null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new LoadingContainer(
        isLoading: _loading,
        child: new RefreshIndicator(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: new StaggeredGridView.countBuilder(
              controller: _scrollController,
              crossAxisCount: 4,
              itemCount: travelItems?.length??0,
              itemBuilder: (BuildContext context, int index) => new _TravelItem(
                index: index,
                item: travelItems[index],
              ),
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            )
          ),
          onRefresh: _handleRefresh
        )
      ),
    );
  }

}

class _TravelItem extends StatelessWidget {
  final TravelItem item;
  final int index;

  const _TravelItem({Key key, this.item, this.index}) : super(key: key);

  String _poiName() {
    return (item.article.pois == null || item.article.pois.length == 0) ? '未知' : item.article.pois[0]?.poiName??'未知';
  }

  _itemImage() {
    return new Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        new Positioned(
          bottom: 8,
          left: 8,
          child: new Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10)
            ),
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: new Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                new LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                )
              ],
            ),
          )
        )
      ],
    );
  }

  _infoText() {
    return new Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.article.author?.coverImage?.dynamicUrl,
                  width: 24,
                  height: 24,
                ),
              ),
              new Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  item.article.likeCount.toString(),
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){
        if (item.article.urls != null && item.article.urls.length > 0) {
          Navigator.push(context, new MaterialPageRoute(builder: (context) => new Webview(
            url: item.article.urls[0].h5Url,
            title: '详情',
          )));
        }
      },
      child: new Card(
        child: new PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              new Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14
                  ),
                ),
              ),
              _infoText()
            ],
          ),
        ),
      ),
    );
  }

}