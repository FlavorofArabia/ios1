import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/api/restful_api/category_api.dart';
import 'package:flavor/models/country.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/blocs.dart';
import '../../blocs/products/products_bloc.dart';
import '../../blocs/sliders/sliders_bloc.dart';
import '../../config/global.dart';
import '../../screens/home/my_drawer.dart';
import '../../screens/home/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/product.dart';
import '../../config/images.dart';
import './product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  auth() {
    Globals.auth(context);
  }

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
          child: Column(
            children: [
              Stack(
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
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                              ),
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
                                  hintText: tr('search for products'),
                                  // hintText: 'ابحث عن المنتجات',
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
                              child: Stack(
                                alignment: Alignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.asset(
                                      Images.LogoTransparent,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Positioned.directional(
                                    end: 0,
                                    textDirection: Directionality.of(context),
                                    child: GestureDetector(
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
                                  ),
                                  Positioned.directional(
                                    start: 0,
                                    textDirection: Directionality.of(context),
                                    child: GestureDetector(
                                      onTap: () {
                                        _scaffoldState.currentState!
                                            .openDrawer();
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
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: AssetImage(Images.SliderImage),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        child: BlocBuilder<SlidersBloc, SlidersState>(
                          builder: (context, state) {
                            if (state is GettingSlidersDone) {
                              if (state.sliders.length > 1) {
                                return Container(
                                  height: 400.0,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                      state.sliders.length,
                                      (i) => Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 400.0,
                                        child: CachedNetworkImage(
                                          imageUrl: state.sliders[i].image!,
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Image.asset(
                                              Images.SliderImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          fadeInCurve: Curves.easeInOut,
                                          fadeInDuration:
                                              Duration(milliseconds: 500),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  child: CachedNetworkImage(
                                    imageUrl: state.sliders.length > 0
                                        ? state.sliders[0].image!
                                        : '',
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child:
                                          // Container()
                                          CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      // child: Icon(Icons.error),
                                      child: Image.asset(
                                        Images.SliderImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeInDuration: Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            } else if (state is GettingSliders ||
                                state is SlidersInitial) {
                              return Shimmer.fromColors(
                                baseColor: Theme.of(context).hoverColor,
                                highlightColor:
                                    Theme.of(context).highlightColor,
                                child: Container(
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0xffe2e2e2)),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                      size: 30,
                                    ),
                                    onPressed: () =>
                                        BlocProvider.of<SlidersBloc>(context)
                                            .add(GetSliders()),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    BlocProvider.of<CartBloc>(context).add(LoadCart());
                  }
                },
                builder: (context, state) {
                  return Container();
                },
              ),
              BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state is CartLoaded) {
                    if (state.updated != null && state.updated!) {
                      return Globals.addToCart(context);
                    }
                  }
                },
                builder: (context, state) {
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                    if (state is GettingProductsDone) {
                      return Container(
                        child: Column(
                          children: List.generate(
                            state.homeProducts.homeProducts!.length,
                            (index) => Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        state.homeProducts.homeProducts![index]
                                            .name!,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      // Text(
                                      //   'تسوق الان',
                                      //   style: TextStyle(
                                      //     color: Theme.of(context).primaryColor,
                                      //     fontSize: 16,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 240,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state
                                          .homeProducts
                                          .homeProducts![index]
                                          .products!
                                          .length,
                                      itemBuilder: (context, productIndex) {
                                        Product product = state
                                            .homeProducts
                                            .homeProducts![index]
                                            .products![productIndex];
                                        return ProductItem(
                                          product: product,
                                          auth: auth,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (state is GettingProducts ||
                        state is ProductsInitial) {
                      return Column(
                        children: [
                          SizedBox(height: 25),
                          Container(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, productIndex) {
                                return ProductItem();
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, productIndex) {
                                return ProductItem();
                              },
                            ),
                          ),
                        ],
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
                                  BlocProvider.of<ProductsBloc>(context)
                                      .add(GetProducts()),
                            ),
                            // Text('اعد المحاولة'),
                            Text(tr('refresh')),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
