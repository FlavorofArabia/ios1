import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/product.dart';
import './product_item.dart';

class Products extends StatefulWidget {
  final List<Product> products;
  Products(this.products);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    products = widget.products.length > itemsPerLoad
        ? widget.products.getRange(0, itemsPerLoad).toList()
        : widget.products.getRange(0, widget.products.length).toList();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int more = 1;
  int itemsPerLoad = 6;

  void _onRefresh() async {
    // // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (widget.products.length - more * itemsPerLoad > itemsPerLoad) {
      more = more + 1;
      products = widget.products.getRange(0, more * itemsPerLoad).toList();
    } else {
      products = widget.products.getRange(0, widget.products.length).toList();
    }
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        staggeredTileBuilder: (_) => new StaggeredTile.fit(2),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) => new ProductItem(
          product: products[index],
          // similarProducts: products,
        ),
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
    );
  }
}
