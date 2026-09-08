import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';
import 'package:sinhala_dictionary_app/core/services/database_service.dart';

class WordRepository {
  final DatabaseService dbService;

  WordRepository({required this.dbService});

  Future<List<WordDefinition>> getSearchResults(
    String query,
    bool isEnglishToSinhala,
  ) async {
    final results = await dbService.searchWords(
      query.trim(),
      isEnglishToSinhala,
    );

    return results.map((e) => WordDefinition.fromMap(e)).toList();
  }
}
