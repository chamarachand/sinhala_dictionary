class WordDefinition {
  final int id;
  final String word;
  final String definition;
  final bool isEnglish;
  final bool isFavourite;

  WordDefinition({
    required this.id,
    required this.word,
    required this.definition,
    required this.isEnglish,
    required this.isFavourite,
  });

  factory WordDefinition.fromMap(Map<String, dynamic> map) {
    return WordDefinition(
      id: map['id'] as int,
      word: map['word'] as String,
      definition: map['definition'] as String,
      isEnglish: map['direction'] == 'en2sn',
      isFavourite: map['is_favourite'] == 1,
    );
  }
}
