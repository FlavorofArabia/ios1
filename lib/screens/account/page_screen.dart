import 'dart:ui';

import '../../api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PageScreen extends StatefulWidget {
  final pageId;
  final String title;
  const PageScreen(this.pageId, this.title);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  dynamic page;

  bool _isLoading = false;
  getData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final res = await UserApi.page(widget.pageId);
      if (res['data'] != null) {
        page = res['data'];
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
        backgroundColor: Color(0xffF8F8F6),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'GE',
            ),
            overflow: TextOverflow.ellipsis,
          ),
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : page == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('حدث خطأ!'),
                        SizedBox(height: 15),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: getData,
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: SingleChildScrollView(
                      child: Html(
                        data: page['description'],
                        style: {
                          "div": Style(
                            fontFamily: 'GE',
                            fontSize: FontSize.em(1),
                          ),
                          "span": Style(
                            fontFamily: 'GE',
                          ),
                          "b": Style(
                            fontFamily: 'GE',
                          ),
                          "p": Style(
                            fontFamily: 'GE',
                            fontSize: FontSize.rem(1),
                          ),
                          "li": Style(
                            fontFamily: 'GE',
                            fontSize: FontSize.rem(1),
                          ),
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
