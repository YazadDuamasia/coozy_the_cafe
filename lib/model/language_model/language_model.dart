class LanguageModel {
  final String? name;
  final String? code;
  final String? file;
  final bool? isRTL;

  LanguageModel({this.name, this.code, this.file, this.isRTL});

  static List<LanguageModel> getLanguages() {
    return [
      LanguageModel(
          name: 'English', code: 'en', file: 'locale_en.json', isRTL: false),
      // LanguageModel(name: 'Arabic', code: 'ar', file: 'locale_ar.json', isRTL: true),
      // LanguageModel(name: 'Farsi/Persian', code: 'fa', file: 'locale_fa.json', isRTL: true),
      // LanguageModel(name: 'Hebrew', code: 'he', file: 'locale_he.json', isRTL: true),
      // Add more languages as needed
    ];
  }
}
