import '../../api/restful_api/product_api.dart';
import '../../components/secodary_button.dart';
import '../../config/config.dart';
import '../../models/product.dart';
import '../../screens/category/products.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String query;
  SearchScreen(this.query);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;
  List<Product> products = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
      products = [];
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      final res = await ProductApi.search(widget.query);
      if (res['data'] != null &&
          res['data'] is Iterable &&
          res['data'].length > 0) {
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'البحث',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : products.length > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Products(products),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          Images.Search,
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.fitWidth,
                        ),
                        Text('لا توجد منتجات'),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: SecondaryButton(
                            title: 'حاول مره اخري',
                            onTap: getData,
                            borderSize: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
