import '../../api/restful_api/product_api.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../components/primary_button.dart';
import '../../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/cart.dart';
import '../../config/config.dart';

class ParsedCartItem extends StatefulWidget {
  final CartItemModel item;
  ParsedCartItem(this.item);

  @override
  _ParsedCartItemState createState() => _ParsedCartItemState();
}

class _ParsedCartItemState extends State<ParsedCartItem> {
  @override
  void initState() {
    if (widget.item.option!.length > 0) {
      getData();
    }
    super.initState();
  }

  Product? product;

  bool _isLoading = false;
  getData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      final res = await ProductApi.product(widget.item.productId);

      if (res['data'] != null) {
        product = Product.fromMap(res['data']);
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

  final imageHeight = 70.0;

  final imageWidth = 70.0;

  final imageRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      // loading
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: new Offset(0.0, 0.0),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            )
          ],
        ),
        child: new Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(imageRadius),
                boxShadow: [
                  new BoxShadow(
                    color: Color(0xffe2e2e2),
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 8.0,
                    spreadRadius: 0.5,
                  )
                ],
              ),
              width: imageWidth,
              height: imageHeight,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              child: new Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 10,
                      width: 200,
                      color: Colors.white,
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    new Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    new Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: CachedNetworkImage(
                    imageUrl:
                        widget.item.thumb != null ? widget.item.thumb! : '',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
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
                Expanded(
                  child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              widget.item.name!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: widget.item.option!.length > 0
                                  ? Wrap(
                                      children: List.generate(
                                        widget.item.option!.length,
                                        (index) => Text(
                                          widget.item.option![index] != null
                                              ? widget.item.option![index]
                                                          ['value'] +
                                                      ' -' ??
                                                  ''
                                              : '',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.item.price!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffF8F9F2),
                  ),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: widget.item.stock!
                            ? () {
                                BlocProvider.of<CartBloc>(context).add(
                                  AddItem(
                                    productId: widget.item.productId,
                                    quantity: 1,
                                  ),
                                );
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.item.stock!
                                ? Color(0xffF8F9F2)
                                : Colors.grey,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: widget.item.stock!
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 55,
                        color: Color(0xffF8F9F2),
                        child: Center(
                          child: Text(
                            '${widget.item.quantity}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<CartBloc>(context).add(
                            UpdateItem(
                              widget.item.key!,
                              widget.item.productId!,
                              widget.item.quantity -= 1,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF8F9F2),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  // (widget.item.priceRaw! * widget.item.quantity).toString() +
                  //     'س.ر',
                  widget.item.total ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isLoading
                    ? CircularProgressIndicator()
                    : widget.item.option!.length > 0
                        ? GestureDetector(
                            onTap: () {
                              product != null
                                  ? showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: OptionsSection(
                                            context,
                                            widget.item.key!,
                                            widget.item.quantity,
                                            product!,
                                            widget.item.option!,
                                          ),
                                        );
                                      },
                                    )
                                  : getData();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffF8F9F2),
                                ),
                              ),
                              child: Text(
                                'تعديل خياراته',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<CartBloc>(context).add(
                      DeleteItem(widget.item.key!),
                    );
                  },
                  child: Container(
                    width: 60,
                    child: Center(
                      child: Image.asset(
                        Images.DeleteIcon,
                        height: 22,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class OptionsSection extends StatefulWidget {
  final BuildContext c;
  final int productKey;
  final int qty;
  final Product product;
  final List<dynamic> initValuesIds;
  OptionsSection(
    this.c,
    this.productKey,
    this.qty,
    this.product,
    this.initValuesIds,
  );

  @override
  _OptionsSectionState createState() => _OptionsSectionState();
}

class _OptionsSectionState extends State<OptionsSection> {
  List<dynamic> selectedValuesIds = [];

  BuildContext? c;
  @override
  void initState() {
    c = widget.c;
    if (widget.initValuesIds.length > 0) {
      for (var i = 0; i < widget.initValuesIds.length; i++) {
        if (widget.product.options![i].type == 'checkbox') {
          selectedValuesIds.add(
            [widget.initValuesIds[i]['product_option_value_id'].toString()],
          );
        } else {
          selectedValuesIds.add(
              widget.initValuesIds[i]['product_option_value_id'].toString());
        }
      }
    }
    // selectedValuesIds = widget.initValuesIds;
    if (selectedValuesIds.length == 0 &&
        widget.product != null &&
        widget.product.options is Iterable) {
      for (var i = 0; i < widget.product.options!.length; i++) {
        selectedValuesIds.add(null);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: 70,
                height: 70,
                child: CachedNetworkImage(
                  imageUrl:
                      widget.product.image != null ? widget.product.image! : '',
                  fit: BoxFit.fill,
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
              SizedBox(width: 10),
              Text(
                widget.product.name!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('خيارات المنتج'),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Color(0xffF8F9F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                widget.product != null &&
                        widget.product.options != null &&
                        widget.product.options is Iterable
                    ? Column(
                        children: List.generate(
                          widget.product.options!.length,
                          (optionIndex) => Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  widget.product.options![optionIndex].name!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              widget.product.options![optionIndex].type !=
                                          null &&
                                      (widget.product.options![optionIndex]
                                                  .type ==
                                              'radio' ||
                                          widget.product.options![optionIndex]
                                                  .type ==
                                              'select' ||
                                          widget.product.options![optionIndex]
                                                  .type ==
                                              'checkbox')
                                  ? widget.product.options![optionIndex].type ==
                                          'select'
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: 'GE',
                                                fontSize: 14,
                                              ),
                                              hint: Text(
                                                'اختر',
                                                style:
                                                    TextStyle(fontFamily: 'GE'),
                                              ),
                                              value: selectedValuesIds[
                                                          optionIndex] !=
                                                      null
                                                  ? selectedValuesIds[
                                                          optionIndex]
                                                      .toString()
                                                  : null,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValuesIds[
                                                      optionIndex] = value;
                                                });
                                              },
                                              items: widget.product
                                                  .options![optionIndex].values!
                                                  .map((x) {
                                                return DropdownMenuItem(
                                                  value: x.productOptionValueId
                                                      .toString(),
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: Text(
                                                      x.name!,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                        fontFamily: 'GE',
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            widget.product.options![optionIndex]
                                                .values!.length,
                                            (index) => Container(
                                              child: Row(
                                                children: [
                                                  widget
                                                              .product
                                                              .options![
                                                                  optionIndex]
                                                              .type ==
                                                          'radio'
                                                      ? Expanded(
                                                          child: Container(
                                                            child:
                                                                RadioListTile(
                                                              title: Text(
                                                                widget
                                                                    .product
                                                                    .options![
                                                                        optionIndex]
                                                                    .values![
                                                                        index]
                                                                    .name!,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'GE',
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              value: widget
                                                                  .product
                                                                  .options![
                                                                      optionIndex]
                                                                  .values![
                                                                      index]
                                                                  .productOptionValueId
                                                                  .toString(),
                                                              groupValue: selectedValuesIds[
                                                                          optionIndex] !=
                                                                      null
                                                                  ? selectedValuesIds[
                                                                          optionIndex]
                                                                      .toString()
                                                                  : '',
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  selectedValuesIds[
                                                                          optionIndex] =
                                                                      value
                                                                          .toString();
                                                                });
                                                              },
                                                              activeColor: Theme
                                                                      .of(context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        )
                                                      : widget
                                                                  .product
                                                                  .options![
                                                                      optionIndex]
                                                                  .type ==
                                                              'checkbox'
                                                          ? Expanded(
                                                              child: Container(
                                                                child:
                                                                    CheckboxListTile(
                                                                  title: Text(
                                                                    widget
                                                                        .product
                                                                        .options![
                                                                            optionIndex]
                                                                        .values![
                                                                            index]
                                                                        .name!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'GE',
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                  value: selectedValuesIds[optionIndex] !=
                                                                              null &&
                                                                          selectedValuesIds[optionIndex]
                                                                              is Iterable
                                                                      ? selectedValuesIds[
                                                                              optionIndex]
                                                                          .contains(
                                                                          widget
                                                                              .product
                                                                              .options![optionIndex]
                                                                              .values![index]
                                                                              .productOptionValueId
                                                                              .toString(),
                                                                        )
                                                                      : false,
                                                                  activeColor: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value!) {
                                                                      if (selectedValuesIds[
                                                                              optionIndex] !=
                                                                          null) {
                                                                        if (!selectedValuesIds[optionIndex].contains(widget
                                                                            .product
                                                                            .options![optionIndex]
                                                                            .values![index]
                                                                            .productOptionValueId
                                                                            .toString())) {
                                                                          selectedValuesIds[optionIndex].add(widget
                                                                              .product
                                                                              .options![optionIndex]
                                                                              .values![index]
                                                                              .productOptionValueId
                                                                              .toString());
                                                                        }
                                                                      } else {
                                                                        selectedValuesIds[
                                                                            optionIndex] = [
                                                                          widget
                                                                              .product
                                                                              .options![optionIndex]
                                                                              .values![index]
                                                                              .productOptionValueId
                                                                              .toString()
                                                                        ];
                                                                      }
                                                                    } else {
                                                                      if (selectedValuesIds[optionIndex].contains(widget
                                                                          .product
                                                                          .options![
                                                                              optionIndex]
                                                                          .values![
                                                                              index]
                                                                          .productOptionValueId
                                                                          .toString())) {
                                                                        selectedValuesIds[optionIndex].remove(widget
                                                                            .product
                                                                            .options![optionIndex]
                                                                            .values![index]
                                                                            .productOptionValueId
                                                                            .toString());
                                                                      }
                                                                    }
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    : Container(),
          ),
          SizedBox(height: 10),
          BlocConsumer<CartBloc, CartState>(
            listener: (ctx, state) {
              if (state is CartFailed) {
                showDialog(
                  context: context,
                  builder: (_) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      content: Text(
                        state.message,
                        style: TextStyle(
                          fontFamily: 'GE',
                          fontSize: 14,
                        ),
                      ),
                      actions: [
                        PrimaryButton(
                          padding: 5,
                          textSize: 16,
                          textWeight: FontWeight.bold,
                          title: "تم",
                          onTap: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                );
              } else if (state is CartLoaded) {
                if (state.updated!) {
                  Navigator.pop(ctx);
                }
              }
            },
            builder: (ctx, state) {
              return PrimaryButton(
                padding: 5,
                textSize: 16,
                textWeight: FontWeight.bold,
                title: "تعديل المنتج",
                onTap: () {
                  for (var i = 0; i < selectedValuesIds.length; i++) {
                    Map options = {};
                    for (var i = 0; i < selectedValuesIds.length; i++) {
                      options[widget.product.options![i].id.toString()] =
                          selectedValuesIds[i];
                    }
                    BlocProvider.of<CartBloc>(context).add(
                      UpdateItem(
                        widget.productKey,
                        widget.product.productId!,
                        widget.qty,
                        option: options,
                      ),
                    );
                    return Navigator.of(context).pop();
                    // return null;
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
