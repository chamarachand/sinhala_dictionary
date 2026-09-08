import 'package:flutter/foundation.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';

@immutable
sealed class SearchState {
  final bool isEnglishToSinhala;

  const SearchState({this.isEnglishToSinhala = true});
}

class SearchIntial extends SearchState {}

class SearchLoaded extends SearchState {
  final List<WordDefinition> results;

  const SearchLoaded({required this.results});
}

class SearchEmpty extends SearchState {}
