// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junior_test/blocs/actions/ActionsQueryBloc.dart';
import 'package:junior_test/blocs/base/bloc_provider.dart';
import 'package:junior_test/model/actions/PromoItem.dart';
import 'package:junior_test/resources/api/RootType.dart';
import 'package:junior_test/model/RootResponse.dart';
import 'package:junior_test/tools/CustomNetworkImageLoader.dart';
import 'package:junior_test/tools/MyColors.dart';
import 'package:junior_test/tools/Strings.dart';
import 'package:junior_test/tools/Tools.dart';
import 'package:junior_test/ui/actions/item/ActionsItemArguments.dart';
import 'package:junior_test/ui/actions/item/ActionsItemWidget.dart';
import 'package:junior_test/ui/base/NewBasePageState.dart';

const int QUANTITY_LOAD_ITEMS = 2;

class ActionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ActionsItemWidget.TAG: (BuildContext context) => ActionsItemWidget(),
      },
      home: Scaffold(
        body: CustomWidget(),
      ),
    );
  }
}

class CustomWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends NewBasePageState<CustomWidget> {
  ActionsQueryBloc bloc;

  List<PromoItem> items = [];
  int page = 0;

  _CustomWidgetState() {
    bloc = ActionsQueryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActionsQueryBloc>(
        bloc: bloc, child: getBaseQueryStream(bloc.shopItemContentStream));
  }

  @override
  Widget onSuccess(RootTypes event, RootResponse response) {
    var actionsList = response.serverResponse.body.promo.list;
    return getNetworkAppBar(
      Strings.actions,
      _getBody(actionsList),
      Strings.actions,
      brightness: Brightness.light,
    );
  }

  @override
  void runOnWidgetInit() {
    bloc.loadActionsList(page, QUANTITY_LOAD_ITEMS);
    this.page++;
  }

  bool _scrollController(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.extentAfter == 0) {
      bloc.loadActionsList(page, QUANTITY_LOAD_ITEMS);
      this.page++;
    }
    return true;
  }

  Widget _getBody(List<PromoItem> itemList) {
    items.addAll(itemList);
    return NotificationListener<ScrollNotification>(
      onNotification: _scrollController,
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(3),
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 3.0,
        itemCount: items.length,
        crossAxisCount: 4,
        itemBuilder: (BuildContext context, int index) =>
            _getItemTile(context, items[index]),
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(2, index.isEven ? 2 : 1),
      ),
    );
  }

  Widget _getItemTile(BuildContext context, PromoItem item) {
    return InkWell(
      child: CustomNetworkImageLoader(
        Tools.getImagePath(item.imgFull),
        Column(children: [
          Expanded(
            child: Center(
              child: Text(
                item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyColors.white,
                ),
              ),
            ),
          ),
          Align(
            child: Text(
              item.shop,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: MyColors.white,
              ),
            ),
            alignment: Alignment.bottomRight,
          ),
        ]),
        true,
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          ActionsItemWidget.TAG,
          arguments: ActionsItemArguments(item.id),
        );
      },
    );
  }
}
