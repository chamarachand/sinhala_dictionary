import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/core/services/database_service.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';

class HistoryRepository {
  final DatabaseService dbService;
  HistoryRepository({required this.dbService});

  Future<List<WordDefinition>> getHistory(
    DictionaryLanguage language, {
    SortOptions sortBy = .latest,
  }) async {
    final data = await dbService.getSearchHistory(language, sortOption: sortBy);

    return data.map((e) => WordDefinition.fromMap(e)).toList();
  }

  Future<void> saveToHistory(int wordId) async {
    await dbService.addToHistory(wordId);
  }

  Future<void> deleteHistory() async {
    await dbService.clearAllHistory();
  }
}
