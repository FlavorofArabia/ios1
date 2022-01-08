class Payment {
  final String? code;
  final String? terms;
  final String? title;
  final int? sortOrder;

  Payment({
    this.code,
    this.terms,
    this.sortOrder,
    this.title,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      code: map['code'] ?? '',
      terms: map['terms'] ?? '',
      title: map['title'] ?? '',
      sortOrder: map['sort_order'] != null
          ? int.tryParse(map['sort_order'].toString())
          : null,
    );
  }
}

class Shipping {
  final String? title;
  final List<Quote>? quote;
  final int? sortOrder;
  final bool? error;

  Shipping({
    this.title,
    this.quote,
    this.sortOrder,
    this.error,
  });

  factory Shipping.fromMap(Map<String, dynamic> map) {
    return Shipping(
      title: map['title'] ?? '',
      quote: map['quote'] != null && map['quote'] is Iterable
          ? List.from(
              map['quote'].map(
                (e) => Quote.fromMap(e),
              ),
            )
          : [],
      sortOrder: map['sort_order'] != null
          ? int.tryParse(map['sort_order'].toString())
          : null,
      error: map['error'] ?? false,
    );
  }
}

class Quote {
  final String? code;
  final String? title;
  final String? cost;
  final String? taxClassId;
  final String? text;

  Quote({
    this.code,
    this.title,
    this.cost,
    this.taxClassId,
    this.text,
  });

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      cost: map['cost'] ?? '',
      taxClassId: map['tax_class_id'] ?? '',
      text: map['text'] ?? '',
    );
  }
}
