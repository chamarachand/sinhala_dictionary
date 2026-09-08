import 'package:sinhala_dictionary_app/core/enums/ai_language.dart';

sealed class AiInsightsState {
  final AiLanguage language;

  const AiInsightsState({required this.language});
}

class AiInsightsInitial extends AiInsightsState {
  AiInsightsInitial({required super.language});
}

class AiInsightsLoading extends AiInsightsState {
  AiInsightsLoading({required super.language});
}

class AiInsightsLoaded extends AiInsightsState {
  final String insights;

  AiInsightsLoaded({required super.language, required this.insights});
}

class AiInsightsError extends AiInsightsState {
  final String message;

  AiInsightsError({required super.language, required this.message});
}
