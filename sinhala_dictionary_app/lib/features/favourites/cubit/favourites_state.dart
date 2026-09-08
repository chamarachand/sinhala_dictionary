import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';

sealed class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoading extends FavouritesState {}

class FavouritesLoaded extends FavouritesState {
  final List<WordDefinition> englishFavourites;
  final List<WordDefinition> sinhalaFavourites;
  final SortOptions sortBy;

  FavouritesLoaded({
    required this.englishFavourites,
    required this.sinhalaFavourites,
    this.sortBy = .latest,
  });
}

class FavouritesEmpty extends FavouritesState {}

class FavouritesError extends FavouritesState {
  final String message;

  FavouritesError({required this.message});
}
