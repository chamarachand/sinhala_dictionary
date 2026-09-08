import 'package:sinhala_dictionary_app/core/constants/url_constants.dart';
import 'package:sinhala_dictionary_app/core/enums/ai_language.dart';
import 'package:sinhala_dictionary_app/core/errors/exceptions.dart';
import 'package:sinhala_dictionary_app/core/services/api_service.dart';
import 'package:sinhala_dictionary_app/core/services/local_storage_service.dart';

class AiInsightsRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  AiInsightsRepository({
    required this.apiService,
    required this.localStorageService,
  });

  Future<({AiLanguage language, String insights})> getAiInsights({
    required String word,
    AiLanguage? language,
  }) async {
    try {
      final targetLanguage = language ?? getSavedLanguage();
      final isSinhala = targetLanguage == AiLanguage.sinhala;

      final request = {"word": word, "level": "B1"};
      final url = isSinhala
          ? UrlConstants.sinhalaInsights
          : UrlConstants.englishInsights;

      final data = await apiService.post(url, request);
      final insights = (data['result'] ?? '') as String;

      return (language: targetLanguage, insights: insights);
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  AiLanguage getSavedLanguage() {
    return localStorageService.getAiLangauge();
  }

  Future<void> setSavedLanguage(AiLanguage language) async {
    await localStorageService.saveAiLanguage(language);
  }
}
