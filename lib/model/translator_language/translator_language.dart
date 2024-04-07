class TranslatorLanguageModel {
  final String name;
  final String code2;

  TranslatorLanguageModel({
    required this.name,
    required this.code2,
  });

  factory TranslatorLanguageModel.fromJson(Map<String, dynamic> json) {
    return TranslatorLanguageModel(
      name: json['name'],
      code2: json['code_2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code_2': code2,
    };
  }

  @override
  String toString() {
    return 'TranslatorLanguageModel{name: $name, code2: $code2}';
  }
}
