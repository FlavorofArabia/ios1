class Language {
  final String? id;
  final String? name;
  final String? code;
  final String? locale;
  final String? image;
  final String? directory;
  final String? sortOrder;
  final String? status;

  Language({
    this.id,
    this.name,
    this.code,
    this.locale,
    this.image,
    this.directory,
    this.sortOrder,
    this.status,
  });

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      id: map['language_id'],
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      locale: map['locale'] ?? '',
      image: map['image'] ?? '',
      directory: map['directory'] ?? '',
      sortOrder: map['sort_order'],
      status: map['status'],
    );
  }
}

class Currency {
  final String? title;
  final String? code;
  final String? symbolLeft;
  final String? symbolRight;

  Currency({
    this.title,
    this.code,
    this.symbolLeft,
    this.symbolRight,
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      title: map['title'],
      code: map['code'],
      symbolLeft: map['symbol_left'],
      symbolRight: map['symbol_right'],
    );
  }
}
