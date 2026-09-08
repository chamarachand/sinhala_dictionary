import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/features/favourites/cubit/favourites_cubit.dart';
import 'package:sinhala_dictionary_app/features/favourites/cubit/favourites_state.dart';
import 'package:sinhala_dictionary_app/features/search/widgets/word_item.dart';
import 'package:sinhala_dictionary_app/features/word_details/screens/word_detail_tab_screen.dart';

class FavouritesScreen extends StatelessWidget {
  final DictionaryLanguage language;
  const FavouritesScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FavouritesCubit, FavouritesState>(
          builder: (context, state) {
            if (state is FavouritesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavouritesEmpty) {
              return const Center(child: Text('No favourites found.'));
            }

            if (state is FavouritesLoaded) {
              final favourites = (language == DictionaryLanguage.english)
                  ? state.englishFavourites
                  : state.sinhalaFavourites;

              return ListView.builder(
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  final item = favourites[index];

                  return WordItem(
                    item: item,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WordDetailTabScreen(wordData: item),
                        ),
                      );

                      if (!context.mounted) return;
                      context.read<FavouritesCubit>().getFavourites();
                    },
                  );
                },
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
