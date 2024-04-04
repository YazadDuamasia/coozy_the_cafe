class TranslatorLanguageModel {
  final String name;
  final String code2;
  final String code3;

  TranslatorLanguageModel({
    required this.name,
    required this.code2,
    required this.code3,
  });

  factory TranslatorLanguageModel.fromJson(Map<String, dynamic> json) {
    return TranslatorLanguageModel(
      name: json['name'],
      code2: json['code_2'],
      code3: json['code_3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code_2': code2,
      'code_3': code3,
    };
  }

  @override
  String toString() {
    return 'TranslatorLanguageModel{name: $name, code2: $code2, code3: $code3}';
  }
}
