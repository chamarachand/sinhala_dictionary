import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/ai_language.dart';
import 'package:sinhala_dictionary_app/core/errors/exceptions.dart';
import 'package:sinhala_dictionary_app/features/ai_insights/cubit/ai_insights_state.dart';
import 'package:sinhala_dictionary_app/features/ai_insights/repository/ai_insights_repository.dart';

class AiInsightsCubit extends Cubit<AiInsightsState> {
  final AiInsightsRepository repository;

  AiInsightsCubit(this.repository)
    : super(AiInsightsInitial(language: repository.getSavedLanguage()));

  Future<void> getAiInsights({
    required String word,
    AiLanguage? language,
  }) async {
    late AiLanguage targetLanguage;

    try {
      targetLanguage = language ?? repository.getSavedLanguage();
      emit(AiInsightsLoading(language: targetLanguage));

      final result = await repository.getAiInsights(
        word: word,
        language: targetLanguage,
      );

      emit(
        AiInsightsLoaded(insights: result.insights, language: result.language),
      );
    } on AppException catch (e) {
      emit(AiInsightsError(language: targetLanguage, message: e.message));
    } catch (e) {
      emit(
        AiInsightsError(
          language: targetLanguage,
          message: 'Something went wrong. Please try again',
        ),
      );
    }
  }

  Future<void> changeLanguage({
    required String word,
    required AiLanguage newLanguage,
  }) async {
    if (state.language == newLanguage && state is! AiInsightsError) return;

    await repository.setSavedLanguage(newLanguage);
    await getAiInsights(word: word, language: newLanguage);
  }
}
