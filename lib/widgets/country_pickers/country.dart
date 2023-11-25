class Country {
  final String name;
  final String isoCode;
  final String iso3Code;
  final String phoneCode;
  final String regionCode;
  final int minLength;
  final int maxLength;

  Country({
    required this.isoCode,
    required this.iso3Code,
    required this.phoneCode,
    required this.name,
    this.regionCode = "",
    required this.minLength,
    required this.maxLength,
  });

  factory Country.fromMap(Map<String, dynamic> map) => Country(
        name: map['name']!,
        isoCode: map['isoCode']!,
        iso3Code: map['iso3Code']!,
        phoneCode: map['phoneCode']!,
        minLength: map['minLength']!,
        maxLength: map['maxLength']!,
        regionCode: map['regionCode']!,
      );

  String get fullCountryCode {
    return phoneCode + regionCode;
  }

  String get displayCC {
    if (regionCode != "") {
      return "$phoneCode $regionCode";
    }
    return phoneCode;
  }
}
