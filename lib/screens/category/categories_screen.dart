import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/screens/home/my_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/images.dart';
import '../../screens/home/search_screen.dart';
import '../../blocs/categories/categories_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import './category_item.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _search = false;
  String searchQuery = '';
  TextEditingController search = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 80,
                color: Theme.of(context).primaryColor,
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 80,
                  child: Image.asset(
                    Images.AppBar,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: _search
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            // controller: search,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              prefixIcon: searchQuery.length > 0
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                SearchScreen(searchQuery),
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            transitionsBuilder: (_,
                                                Animation<double> animation,
                                                __,
                                                Widget child) {
                                              return Opacity(
                                                opacity: animation.value,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Transform.rotate(
                                        angle: pi,
                                        child: Icon(Icons.send),
                                      ),
                                    )
                                  : Icon(Icons.search),
                              suffixIcon: searchQuery.length > 0
                                  ? GestureDetector(
                                      child: Icon(Icons.close),
                                      onTap: () {
                                        print('clear');
                                        setState(() {
                                          searchQuery = '';
                                          search.text = '';
                                        });
                                      },
                                    )
                                  : GestureDetector(
                                      child: Icon(Icons.close),
                                      onTap: () {
                                        setState(() {
                                          _search = false;
                                        });
                                      },
                                    ),
                              prefixStyle: TextStyle(color: Colors.black45),
                              filled: true,
                              fillColor: Color(0xfff1f1f1),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'ابحث عن المنتجات',
                              hintStyle: TextStyle(color: Colors.black45),
                              contentPadding: EdgeInsets.all(5),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                searchQuery = value;
                                search.text = value;
                              });
                            },
                            onSubmitted: (String value) {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      SearchScreen(searchQuery),
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  transitionsBuilder: (_,
                                      Animation<double> animation,
                                      __,
                                      Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldState.currentState!.openDrawer();
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.bars,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                // child: Image.asset(
                                //   Images.MenuIcon,
                                //   width: 25,
                                //   height: 25,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              Image.asset(
                                Images.LogoTransparent,
                                height: 55,
                                fit: BoxFit.fitHeight,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _search = true;
                                  });
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.search,
                                  color: Colors.white,
                                ),
                                // child: Image.asset(
                                //   Images.SearchIcon,
                                //   width: 25,
                                //   height: 25,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BlocBuilder<CategoriesBloc, CategoriesState>(
                          builder: (context, state) {
                            if (state is GettingCategoriesDone) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 3,
                                staggeredTileBuilder: (_) =>
                                    new StaggeredTile.fit(1),
                                mainAxisSpacing: 12.0,
                                crossAxisSpacing: 12.0,
                                itemCount: state.categories.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        new CategoryItem(
                                  category: state.categories[index],
                                ),
                              );
                            } else if (state is GettingCategories ||
                                state is CategoriesInitial) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 3,
                                staggeredTileBuilder: (_) =>
                                    new StaggeredTile.fit(1),
                                mainAxisSpacing: 12.0,
                                crossAxisSpacing: 12.0,
                                itemCount: 9,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        new CategoryItem(),
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.refresh,
                                        size: 30,
                                      ),
                                      onPressed: () =>
                                          BlocProvider.of<CategoriesBloc>(
                                                  context)
                                              .add(GetCategories()),
                                    ),
                                    Text(tr('refresh')),
                                    // Text('اعد المحاولة'),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
