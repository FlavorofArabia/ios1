class HomeProductsRes {
  final List<HomeProducts>? homeProducts;

  HomeProductsRes({this.homeProducts});

  factory HomeProductsRes.fromJson(Map<String, dynamic> json) {
    List<HomeProducts> home = [];

    for (var i = 0; i < (json).keys.length; i++) {
      home.add(HomeProducts.fromJson(json.values.toList()[i]));
    }

    return HomeProductsRes(homeProducts: home);
  }
}

class HomeProducts {
  final String? id;
  final String? name;
  final String? image;
  final String? originalImage;
  final List<Product>? products;

  HomeProducts({
    this.id,
    this.name,
    this.image,
    this.originalImage,
    this.products,
  });

  factory HomeProducts.fromJson(Map<String, dynamic> json) {
    return HomeProducts(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      originalImage: json['original_image'] ?? '',
      products: json['products'] != null
          ? List<Product>.from(
              json['products'].map(
                (p) => Product.fromMap(p),
              ),
            ).toList()
          : [],
    );
  }
}

class Product {
  final int? id;
  final int? productId;
  final String? thumb;
  final String? name;
  final String? manufacturer;
  final String? sku;
  final String? model;
  final String? image;
  final List<String>? images;
  final String? originalImage;
  final List<String>? originalImages;
  final int? priceExcludingTax;
  final String? priceExcludingTaxFormated;
  final int? price;
  final String? priceFormated;
  final String? total;
  final double? rate;
  final String? description;
  // final List attributeGroups;
  // final bool special;
  // final int specialExcludingTax;
  // final String specialExcludingTaxFormated;
  // final String specialFormated;
  // final String specialStartDate;
  // final String specialEndDate;
  // final List discounts;
  final List<Option>? options;
  final int? minimum;
  // final String metaTitle;
  // final String metaDescription;
  // final String metaKeyword;
  // final String seoUrl;
  // final String tag;
  // final String upc;
  // final String ean;
  // final String jan;
  // final String isbn;
  // final String mpn;
  // final String location;
  // final String stockStatus;
  // final int stockStatusId;
  // final int manufacturerId;
  // final int taxClassId;
  // final String dateAvailable;
  // final String weight;
  // final int weightClassId;
  // final String length;
  // final String width;
  // final String height;
  // final int lengthClassId;
  // final String subtract;
  // final String sortOrder;
  // final String status;
  // final String dateAdded;
  // final String dateModified;
  // final String viewed;
  // final String weightClass;
  // final String lengthClass;
  // final String shipping;
  // final reward;
  // final String points;
  // final List category;
  final int? quantity;
  // final reviews;
  // final List recurrings;
  final List<Product>? relatedProducts;

  Product({
    this.id,
    this.productId,
    this.thumb,
    this.name,
    this.manufacturer,
    this.sku,
    this.model,
    this.image,
    this.images,
    this.originalImage,
    this.originalImages,
    this.priceExcludingTax,
    this.priceExcludingTaxFormated,
    this.price,
    this.priceFormated,
    this.total,
    this.rate,
    this.description,
    // this.attributeGroups,
    // this.special,
    // this.specialExcludingTax,
    // this.specialExcludingTaxFormated,
    // this.specialFormated,
    // this.specialStartDate,
    // this.specialEndDate,
    // this.discounts,
    this.options,
    this.minimum,
    // this.metaTitle,
    // this.metaDescription,
    // this.metaKeyword,
    // this.seoUrl,
    // this.tag,
    // this.upc,
    // this.ean,
    // this.jan,
    // this.isbn,
    // this.mpn,
    // this.location,
    // this.stockStatus,
    // this.stockStatusId,
    // this.manufacturerId,
    // this.taxClassId,
    // this.dateAvailable,
    // this.weight,
    // this.weightClassId,
    // this.length,
    // this.width,
    // this.height,
    // this.lengthClassId,
    // this.subtract,
    // this.sortOrder,
    // this.status,
    // this.dateAdded,
    // this.dateModified,
    // this.viewed,
    // this.weightClass,
    // this.lengthClass,
    // this.shipping,
    // this.reward,
    // this.points,
    // this.category,
    this.quantity,
    // this.reviews,
    // this.recurrings,
    this.relatedProducts,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        productId: int.tryParse(map['product_id'].toString()),
        thumb: map['thumb'] ?? '',
        name: map['name'] ?? '',
        manufacturer: map['manufacturer'] ?? '',
        sku: map['sku'] ?? '',
        model: map['model'] ?? '',
        image: map['image'] ?? '',
        images: map['images'] != null && map['images'] is Iterable
            ? List.from(map['images'])
            : [],
        originalImage: map['original_image'] ?? '',
        originalImages: map['original_images'] != null
            ? List.from(map['original_images'].map((e) => e))
            : [],
        priceExcludingTax:
            int.tryParse(map['price_excluding_tax'].toString()) ?? null,
        priceExcludingTaxFormated: map['price_excluding_tax_formated'] ?? '',
        price: map['price'] != null
            ? int.tryParse(map['price'].toString()) ?? null
            : null,
        priceFormated: map['price_formated'] ?? '',
        total: map['total'] ?? '',
        rate:
            map['rating'] != null ? double.parse(map['rating'].toString()) : 0,
        description: map['description'] ?? '',
        // attributeGroups: map['attribute_groups'] ?? [],
        // special: map['special'] ?? false,
        // specialExcludingTax: map['special_excluding_tax'],
        // specialExcludingTaxFormated: map['special_excluding_tax_formated'] ?? '',
        // specialFormated: map['special_formated'] ?? '',
        // specialStartDate: map['special_start_date'] ?? '',
        // specialEndDate: map['special_end_date'] ?? '',
        // discounts: map['discounts'] ?? [],
        // options: map['options'] ?? [],
        options: map['options'] != null
            ? List<Option>.from(
                map["options"].map(
                  (x) => Option.fromJson(x),
                ),
              )
            : [],
        minimum:
            map['minimum'] != null ? int.parse(map['minimum'].toString()) : 1,
        // metaTitle: map['meta_title'] ?? '',
        // metaDescription: map['meta_description'] ?? '',
        // metaKeyword: map['meta_keyword'] ?? '',
        // seoUrl: map['seo_url'] ?? '',
        // tag: map['tag'] ?? '',
        // upc: map['upc'] ?? '',
        // ean: map['ean'] ?? '',
        // jan: map['jan'] ?? '',
        // isbn: map['isbn'] ?? '',
        // mpn: map['mpn'] ?? '',
        // location: map['location'] ?? '',
        // stockStatus: map['stock_status'] ?? '',
        // manufacturerId: map['manufacturer_id'],
        // stockStatusId: map['stock_status_id'],
        // taxClassId: map['tax_class_id'],
        // length: map["length"] ?? "",
        // width: map["width"] ?? "",
        // height: map["height"] ?? "",
        // lengthClassId: map["length_class_id"],
        // subtract: map["subtract"] ?? '',
        // sortOrder: map["sort_order"] ?? '',
        // status: map["status"] ?? '',
        // dateAdded: map["date_added"] ?? '',
        // dateModified: map["date_modified"] ?? '',
        // viewed: map["viewed"] ?? '',
        // weightClass: map["weight_class"] ?? "كلغ",
        // lengthClass: map["length_class"] ?? "سم",
        // shipping: map["shipping"] ?? "",
        // reward: map["reward"],
        // points: map["points"] ?? "0",
        // category: map["category"] ?? [],
        quantity: map["quantity"] != null
            ? int.tryParse(map["quantity"].toString()) ?? 1
            : 1,
        // reviews: map["reviews"] ?? {},
        // recurrings: map["recurrings"] ?? [],
        relatedProducts: map['related_products'] != null &&
                map['related_products'] is Iterable &&
                map['related_products'].length > 0
            ? List<Product>.from(
                map["related_products"].map(
                  (x) => Product.fromMap(x),
                ),
              )
            : []
        // relatedProducts: map["related_products"] ?? [],
        );
  }
}

class Option {
  final int? id;
  final List<OptionValue>? values;
  final int? optionId;
  final String? name;
  final String? type;
  final String? value;
  final String? isRequired;

  Option({
    this.id,
    this.values,
    this.optionId,
    this.name,
    this.type,
    this.value,
    this.isRequired,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: int.tryParse(json['product_option_id'].toString()),
        values: json['option_value'] != null
            ? List.from(
                json['option_value'].map(
                  (e) => OptionValue.fromJson(e),
                ),
              )
            : [],
        optionId: int.tryParse(json["option_id"].toString()),
        name: json["name"] ?? "",
        type: json["type"],
        value: json["value"] ?? "",
        isRequired: json["required"],
      );
}

class OptionValue {
  final image;
  final int? price;
  final String? priceFormated;
  final int? priceExcludingTax;
  final String? priceExcludingTaxFormated;
  final String? pricePrefix;
  final int? productOptionValueId;
  final int? optionValueId;
  final String? name;
  final int? quantity;

  OptionValue({
    this.image,
    this.price,
    this.priceFormated,
    this.priceExcludingTax,
    this.priceExcludingTaxFormated,
    this.pricePrefix,
    this.productOptionValueId,
    this.optionValueId,
    this.name,
    this.quantity,
  });

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
        image: json["image"] ?? '',
        price:
            json["price"] != null ? int.tryParse(json["price"].toString()) : 0,
        priceFormated: json["price_formated"] ?? "0س.ر",
        priceExcludingTax: json["price_excluding_tax"] != null
            ? int.tryParse(json["price_excluding_tax"].toString())
            : 0,
        priceExcludingTaxFormated:
            json["price_excluding_tax_formated"] ?? "0س.ر",
        pricePrefix: json["price_prefix"] ?? "+",
        productOptionValueId: json["product_option_value_id"],
        optionValueId: json["option_value_id"],
        name: json["name"] ?? "",
        quantity: json["quantity"] != null
            ? int.tryParse(json["quantity"].toString())
            : 0,
      );
}
