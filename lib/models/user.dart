class User {
  final String? customerId;
  final String? customerGroupId;
  final String? storeId;
  final String? languageId;
  final String? firstName;
  final String? lastName;
  final String? telephone;
  final String? email;
  final String? fax;
  final List? wishlist;
  final String? newsletter;
  final String? addressId;
  final String? ip;
  final String? status;
  final String? safe;
  final String? code;
  final String? dateAdded;
  final List? customFields;
  final List? accountCustomField;
  final String? wishlistTotal;
  final String? cartCountProducts;

  User({
    this.customerId,
    this.customerGroupId,
    this.storeId,
    this.languageId,
    this.firstName,
    this.lastName,
    this.telephone,
    this.email,
    this.fax,
    this.wishlist,
    this.newsletter,
    this.addressId,
    this.ip,
    this.status,
    this.safe,
    this.code,
    this.dateAdded,
    this.customFields,
    this.accountCustomField,
    this.wishlistTotal,
    this.cartCountProducts,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      customerId: json['customer_id'].toString(),
      customerGroupId: json['customer_group_id'].toString(),
      storeId: json['store_id'].toString(),
      languageId: json['language_id'].toString(),
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'].toString(),
      fax: json['fax'] ?? '',
      wishlist: json['wishlist'] ?? [],
      newsletter: json['newsletter'].toString(),
      addressId: json['address_id'].toString(),
      ip: json['ip'] ?? '',
      status: json['status'].toString(),
      safe: json['safe'].toString(),
      code: json['code'] ?? '',
      dateAdded: json['date_added'] ?? '',
      customFields: json['custom_fields'] ?? [],
      accountCustomField: json['account_custom_field'] ?? [],
      wishlistTotal: json['wishlist_total'].toString(),
      cartCountProducts: json['cart_count_products'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class Location {
  final double? long;
  final double? lat;

  Location({
    this.long,
    this.lat,
  });

  factory Location.fromMap(Map<String, dynamic> json) {
    return Location(
      long: json['long'],
      lat: json['lat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'long': long,
      'lat': lat,
    };
  }
}
