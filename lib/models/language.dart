class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "πͺπΈ", "Spanish", "es"),
      Language(2, "πΊπΈ", "English", "en"),
      Language(3, "π¨πΊ", "Catalan", "ca")
    ];
  }
}
