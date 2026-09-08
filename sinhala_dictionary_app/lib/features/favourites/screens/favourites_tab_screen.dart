import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/core/widgets/delete_confirmation_dialog.dart';
import 'package:sinhala_dictionary_app/core/widgets/sort_popup_menu_button.dart';
import 'package:sinhala_dictionary_app/features/favourites/cubit/favourites_cubit.dart';
import 'package:sinhala_dictionary_app/features/favourites/cubit/favourites_state.dart';
import 'package:sinhala_dictionary_app/features/favourites/screens/favourites_screen.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_cubit.dart';

class FavouritesTabScreen extends StatefulWidget {
  final Widget drawer;
  const FavouritesTabScreen({super.key, required this.drawer});

  @override
  State<FavouritesTabScreen> createState() => _FavouritesTabScreenState();
}

class _FavouritesTabScreenState extends State<FavouritesTabScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouritesCubit>().getFavourites();
  }

  Future<void> onDeletePressed() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => const DeleteConfirmationDialog(text: 'favourites'),
    );

    if (confirmed == true && mounted) {
      context.read<HistoryCubit>().clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favourites"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "English"),
              Tab(text: "Sinhala"),
            ],
          ),
          actions: [
            BlocBuilder<FavouritesCubit, FavouritesState>(
              builder: (context, state) {
                final value = (state is FavouritesLoaded)
                    ? state.sortBy
                    : SortOptions.latest;

                return SortPopupMenuButton(
                  value: value,
                  onSelected: context.read<FavouritesCubit>().sortFavourites,
                  enableSortByViewCount: false,
                );
              },
            ),

            IconButton(
              onPressed: onDeletePressed,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        drawer: widget.drawer,
        body: const TabBarView(
          children: [
            FavouritesScreen(language: DictionaryLanguage.english),
            FavouritesScreen(language: DictionaryLanguage.sinhala),
          ],
        ),
      ),
    );
  }
}
