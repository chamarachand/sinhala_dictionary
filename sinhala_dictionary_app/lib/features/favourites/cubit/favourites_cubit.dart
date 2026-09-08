import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/features/favourites/cubit/favourites_state.dart';
import 'package:sinhala_dictionary_app/features/favourites/repositories/favourites_repository.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  final FavouritesRepository repository;
  FavouritesCubit(this.repository) : super(FavouritesInitial());

  Future<void> getFavourites({SortOptions sortBy = .latest}) async {
    final favouriteWords = await Future.wait([
      repository.getFavourites(DictionaryLanguage.english, sortBy: sortBy),
      repository.getFavourites(DictionaryLanguage.sinhala, sortBy: sortBy),
    ]);

    emit(
      FavouritesLoaded(
        englishFavourites: favouriteWords[0],
        sinhalaFavourites: favouriteWords[1],
        sortBy: sortBy,
      ),
    );
  }

  Future<void> sortFavourites(SortOptions sortBy) async {
    await getFavourites(sortBy: sortBy);
  }
}
