class Address {
  final int? addressId;
  final String? firstname;
  final String? lastname;
  final String? company;
  final String? address1;
  final String? address2;
  final String? postCode;
  final String? city;
  final int? zoneId;
  final String? zone;
  final String? zoneCode;
  final int? countryId;
  final String? country;
  final String? isoCode2;
  final String? isoCode3;
  final String? addressFormat;

  Address({
    this.addressId,
    this.firstname,
    this.lastname,
    this.company,
    this.address1,
    this.address2,
    this.postCode,
    this.city,
    this.zoneId,
    this.zone,
    this.zoneCode,
    this.countryId,
    this.country,
    this.isoCode2,
    this.isoCode3,
    this.addressFormat,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressId: map['address_id'] != null
          ? int.tryParse(map['address_id'].toString())
          : null,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      company: map['company'] ?? '',
      address1: map['address_1'] ?? '',
      address2: map['address_2'] ?? '',
      city: map['city'] ?? '',
      zoneId: map['zone_id'] != null
          ? int.tryParse(map['zone_id'].toString())
          : null,
      zone: map['zone'] ?? '',
      zoneCode: map['zone_code'] ?? '',
      countryId: map['country_id'] != null
          ? int.tryParse(map['country_id'].toString())
          : null,
      country: map['country'] ?? '',
      isoCode2: map['iso_code_2'] ?? '',
      isoCode3: map['iso_code_3'] ?? '',
      addressFormat: map['address_format'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_1': address1,
      'country_id': countryId,
      'zone_id': zoneId,
      'city': city,
    };
  }
}

class Country {
  final int? countryId;
  final String? name;
  final String? isoCode2;
  final String? isoCode3;
  final String? addressFormat;
  final String? postcodeRequired;
  final String? status;
  final String? image ;

  Country({
    this.countryId,
    this.name,
    this.isoCode2,
    this.isoCode3,
    this.addressFormat,
    this.postcodeRequired,
    this.status,
     this.image,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      countryId: map['country_id'],
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      isoCode2: map['iso_code_2'] ?? '',
      isoCode3: map['iso_code_3'] ?? '',
      addressFormat: map['address_format'] ?? '',
      postcodeRequired: map['postcode_required'] != null
          ? map['postcode_required'].toString()
          : '',
      status: map['status'] != null ? map['status'].toString() : '',

    );
  }
}

class Zone {
  final int? zoneId;
  final int? countryId;
  final String? name;
  final String? code;
  final String? status;

  Zone({
    this.zoneId,
    this.countryId,
    this.name,
    this.code,
    this.status,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        zoneId: json['zone_id'] != null
            ? int.tryParse(json['zone_id'].toString())
            : null,
        countryId: json['country_id'] != null
            ? int.tryParse(json['country_id'].toString())
            : null,
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        status: json['status'] != null ? json['status'].toString() : '',
      );
}
