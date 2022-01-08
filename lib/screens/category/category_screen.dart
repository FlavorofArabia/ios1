import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/config/images.dart';
import 'package:flavor/models/country.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../config/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../api/restful_api/category_api.dart';
import './product_item.dart';
import './products.dart';

class CategoryScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final List filters;
  CategoryScreen({this.categoryId, this.categoryName, required this.filters});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Product> products = [];
  List<Category> categories = [];
  bool gridView = false;

  bool _isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      final res = await CategoryApi.productsCategory(widget.categoryId);
      if (res['data'] != null) {
        for (var i = 0; i < res['data'].length; i++) {
          products.add(Product.fromMap(res['data'][i]));
        }
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  applyFilter(Country selectedCountry) {
    filteredCountry = selectedCountry;
    if (selectedCountry.countryId != null) {
      filter(selectedCountry.countryId);
    }
  }

  bool _filterd = false;
  Country? filteredCountry;
  List<Product> filteredProducts = [];
  filter(countryId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      filteredProducts = [];
      final res = await CategoryApi.filter(widget.categoryId, countryId);
      if (res['data'] != null) {
        for (var i = 0; i < res['data'].length; i++) {
          filteredProducts.add(Product.fromMap(res['data'][i]));
        }
        _filterd = true;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _filterd = false;
        _isLoading = false;
      });
    }
  }

  cancelFilter() {
    setState(() {
      filteredCountry = null;
      _filterd = false;
      filteredProducts = products;
    });
    getData();
  }

  Widget build(BuildContext context) {
    return
        // Directionality(
        //   textDirection: TextDirection.rtl,
        //   child:
        Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'GE',
          ),
        ),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: Image(
            image: AssetImage(Images.AppBar),
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          widget.filters.length > 0
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CountriesFilter(
                              widget.filters,
                              (selectedCountry) => applyFilter(selectedCountry),
                              filteredCountry,
                              () => cancelFilter(),
                            );
                          });
                    },
                    child: FaIcon(
                      FontAwesomeIcons.globe,
                      color: Colors.white,
                      // size: 30,
                    ),
                    // child: Icon(
                    //   Icons.filter_alt,
                    //   color: Colors.white,
                    //   size: 30,
                    // ),
                  ),
                )
              : Container(),
        ],
      ),
      body:
          //  Directionality(
          //   textDirection: TextDirection.rtl,
          //   child:
          SingleChildScrollView(
        child: Stack(
          children: [
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
            Container(
              margin: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height,
              child: _isLoading
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        staggeredTileBuilder: (_) => new StaggeredTile.fit(2),
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        itemCount: 16,
                        itemBuilder: (BuildContext context, int index) =>
                            new ProductItem(),
                      ),
                    )
                  : _filterd
                      ? filteredProducts.length > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Products(filteredProducts),
                            )
                          : Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('No Data in this country'),
                            )
                      : products.length == 0
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: getData,
                                    child: Icon(Icons.refresh),
                                  ),
                                  SizedBox(height: 10),
                                  Text(tr('refresh')),
                                  // Text('اعد المحاولة'),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Products(products),
                            ),
            ),
          ],
        ),
        // ),
      ),
      // ),
    );
  }
}

class CountriesFilter extends StatefulWidget {
  List filters;
  final Function filter;
  Country? initialCountry;
  final Function cancelFilter;
  CountriesFilter(
    this.filters,
    this.filter,
    this.initialCountry,
    this.cancelFilter,
  );

  @override
  _CountriesFiltreState createState() => _CountriesFiltreState();
}

class _CountriesFiltreState extends State<CountriesFilter> {
  @override
  void initState() {
    super.initState();
    arrengeFilter();
    selectedCountry = widget.initialCountry;
  }

  List<Country> countries = [];
  arrengeFilter() {
    countries = [];
    if (widget.filters.length > 0) {
      Map countryFilter = widget.filters.first ;
          // (element) => element['name'] == 'country',
        // orElse: () => widget.filters.first);
    //  if (countryFilter['filter']['name'].containsValue((int x)))
      print('Country details is ..');
      print(countryFilter['filter']);

      if (countryFilter != null && countryFilter['filter'] != null) {
        for (var i = 0; i < countryFilter['filter'].length; i++) {

          countries.add(
            Country(
              countryId: int.tryParse(
                  countryFilter['filter'][i]['filter_id'].toString()),
              name: countryFilter['filter'][i]['name'],
              image: countryFilter['filter'][i]['image'],
            ),
          );
        }
      }
    }
  }

  Country? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: selectedCountry != null
          ? OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedCountry = null;
                });
                widget.cancelFilter();
                Navigator.pop(context);
              },
              child: Text('clear filter'),
            )
          : null,
      titlePadding: EdgeInsets.all(0),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              countries.length,
              (index) => Container(
                child: RadioListTile<String>(
                  title: Row(
                    children: [
                      Text(
                        countries[index].name!.substring(0,countries[index].name!.indexOf('(')) ?? '' ,
                        style: TextStyle(
                          fontFamily: 'GE',
                          fontSize: 14,
                         //fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                      '(' + countries[index].name!.substring(countries[index].name!.indexOf('(')+1) ?? '' ,
                      ),
                    ],
                  ),
                  secondary: Container(
                        width: 40,
                       height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(countries[index].image ?? ''),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                  ),
                  value: countries[index].countryId?.toString() ?? '',
                  groupValue: selectedCountry?.countryId != null
                      ? selectedCountry?.countryId.toString()
                      : '',
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = countries.firstWhere(
                        (element) => element.countryId.toString() == value,
                        orElse: () => Country(),
                      );
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(0),
      actions: [
        ElevatedButton(
          child: Text(tr('filter')),
          onPressed: () {
            widget.filter(selectedCountry);
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(tr('cancel')),
        )
      ],
    );
  }
}
