import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/core/services/database_service.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';

class FavouritesRepository {
  final DatabaseService dbService;
  FavouritesRepository({required this.dbService});

  Future<List<WordDefinition>> getFavourites(
    DictionaryLanguage language, {
    SortOptions sortBy = .latest,
  }) async {
    final data = await dbService.getFavoriteWords(language, sortOption: sortBy);

    return data.map((e) => WordDefinition.fromMap(e)).toList();
  }

  Future<bool> checkIsFavourite(int wordId) async {
    return await dbService.isFavourite(wordId);
  }

  Future<bool> toggleFavourite(int wordId) async {
    return await dbService.toggleFavourite(wordId);
  }
}
