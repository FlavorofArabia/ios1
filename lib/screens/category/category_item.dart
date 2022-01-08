import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/category.dart';
import './category_screen.dart';

class CategoryItem extends StatelessWidget {
  final Category? category;
  CategoryItem({this.category});

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      return GestureDetector(
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => CategoryScreen(
              categoryId: category!.id,
              categoryName: category!.name,
              filters: category?.filters?['filter_groups'] != null
                  ? category?.filters!['filter_groups']
                  : [],
            ),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            },
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Color(0xffF1F1F1)),
          ),
          child: Column(
            children: [
              Container(
                width: 85,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: CachedNetworkImage(
                  imageUrl: category!.image != null
                      ? category!.image!
                      : 'https://via.placeholder.com/350x150',
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Center(child: Icon(Icons.error)),
                  ),
                  fadeInCurve: Curves.easeInOut,
                  fadeInDuration: Duration(milliseconds: 500),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  category!.name!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  strutStyle: StrutStyle(height: 1),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black54,
                    letterSpacing: 1.2,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'يوجد ${category!.productCount} منتج',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
                width: 50,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                height: 10,
                width: 70,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                height: 10,
                width: 40,
                color: Colors.white,
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffe2e2e2)),
                  ),
                ),
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    }
  }
}
