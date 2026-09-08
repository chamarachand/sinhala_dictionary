import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/features/search/repository/search_repository.dart';
import 'package:sinhala_dictionary_app/features/search/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final WordRepository repository;
  SearchCubit(this.repository) : super(SearchIntial());

  void reset() => emit(SearchIntial());

  Future<void> searchWords({
    required String query,
    required bool isEnglishToSinhala,
  }) async {
    final searchResults = await repository.getSearchResults(
      query,
      isEnglishToSinhala,
    );

    if (searchResults.isNotEmpty) {
      emit(SearchLoaded(results: searchResults));
    } else {
      emit(SearchEmpty());
    }
  }
}
