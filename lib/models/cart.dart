import './product.dart';

class Cart {
  String? weight;
  List<CartItemModel>? products;
  String? total;

  Cart({
    this.weight,
    this.products,
    this.total,
  });

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
        products: map['products'] != null
            ? List.from(
                map['products'].map((e) => CartItemModel.fromMap(e)),
              )
            : [],
        weight: map['weight'] ?? '',
        total: map['totals'] != null ? map['totals'][0]['text'] : '');
  }
}

class CartItemModel {
  int? key;
  int? productId;
  String? name;
  String? thumb;
  String? model;
  List? option;
  List<Option>? relatedOptions;
  int quantity;
  String? recurring;
  bool? stock;
  String? reward;
  String? price;
  String? total;
  int? priceRaw;
  int? totalRaw;
  int? itemAvailableQty;

  CartItemModel({
    this.key,
    this.productId,
    this.name,
    this.thumb,
    this.model,
    this.option,
    this.relatedOptions,
    required this.quantity,
    this.recurring,
    this.stock,
    this.reward,
    this.price,
    this.total,
    this.priceRaw,
    this.totalRaw,
    this.itemAvailableQty,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      key: int.parse(map['key'].toString()),
      productId: int.tryParse(map['product_id'].toString()),
      name: map['name'] ?? '',
      thumb: map['thumb'] ?? '',
      option: map['option'] ?? [],
      relatedOptions: map['product_options'] != null
          ? List<Option>.from(
              map["product_options"].map(
                (x) => Option.fromJson(x),
              ),
            )
          : [],
      model: map['model'],
      quantity:
          map['quantity'] != null ? int.parse(map['quantity'].toString()) : 0,
      recurring: map['recurring'] ?? '',
      stock: map['stock'] ?? false,
      reward: map['reward'] ?? '',
      price: map['price'] ?? '',
      total: map['total'] ?? '',
      priceRaw: map['price_raw'] ?? '',
      totalRaw: map['total_raw'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'thumb': this.thumb,
      'quantity': this.quantity.toString(),
      'option': this.option,
      'model': this.model,
      'recurring': this.recurring.toString(),
      'stock': this.stock,
      'reward': this.reward,
      'price': this.price,
      'total': this.total,
      'price_raw': this.priceRaw,
      'total_raw': this.totalRaw,
    };
  }
}
