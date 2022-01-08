import './product.dart';

class Order {
  final int? id;
  final String? name;
  final String? status;
  final String? dateAdded;
  final List<Product>? products;
  final String? total;
  final String? currencyCode;
  final double? currencyValue;
  final double? totalRaw;
  final int? timeStamp;
  final Currency? currency;

  Order({
    this.id,
    this.name,
    this.status,
    this.dateAdded,
    this.products,
    this.total,
    this.currencyCode,
    this.currencyValue,
    this.totalRaw,
    this.timeStamp,
    this.currency,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['order_id'] != null
          ? int.tryParse(map['order_id'].toString())
          : null,
      name: map['name'] ?? '',
      status: map['status'] != null
          ? map['status'] ?? ''
          : map['histories'] != null && map['histories'] is Iterable
              ? map['histories'][0]['status'] ?? ''
              : '',
      dateAdded: map['date_added'] ?? '',
      products: map['products'] != null &&
              map['products'] is Iterable &&
              map['products'].length > 0
          ? List<Product>.from(
              map["products"].map(
                (x) => Product.fromMap(x),
              ),
            )
          : [],
      total:
          map['total'] != null ? map['total'].toString() : map['total'] ?? '',
      currencyCode: map['currency_code'] ?? '',
      currencyValue: map['currency_value'] != null
          ? double.tryParse(map['currency_value'].toString())
          : 0,
      totalRaw: map['total_raw'] != null
          ? double.tryParse(map['total_raw'].toString())
          : 0,
      timeStamp: map['timestamp'] != null
          ? int.tryParse(map['timestamp'].toString())
          : null,
      currency: map['currency'] != null
          ? Currency.fromMap(map['currency'])
          : Currency.fromMap({}),
    );
  }
}

class Currency {
  final int? id;
  final String? symbolLeft;
  final String? symbolRight;
  final String? decimalPlace;
  final String? value;

  Currency({
    this.id,
    this.symbolLeft,
    this.symbolRight,
    this.decimalPlace,
    this.value,
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['currency_id'] != null
          ? int.tryParse(map['currency_id'].toString())
          : null,
      symbolLeft: map['symbol_left'] ?? '',
      symbolRight: map['symbol_right'] ?? '',
      decimalPlace: map['decimal_place'] ?? '',
      value: map['value'] ?? '',
    );
  }
}

class OrdersRes {
  final List<OrderType>? homeProducts;

  OrdersRes({this.homeProducts});

  factory OrdersRes.fromJson(Map<String, dynamic> json) {
    List<OrderType> home = [];

    for (var i = 0; i < (json).keys.length; i++) {
      home.add(OrderType.fromList(json.values.toList()[i]));
    }

    return OrdersRes(homeProducts: home);
  }
}

class OrderType {
  final List<Order>? orders;

  OrderType({
    this.orders,
  });

  factory OrderType.fromList(List list) {
    return OrderType(
      orders: list != null
          ? List<Order>.from(
              list.map(
                (p) => Order.fromMap(p),
              ),
            ).toList()
          : [],
    );
  }
}
