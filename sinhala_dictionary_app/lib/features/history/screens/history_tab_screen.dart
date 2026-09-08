import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_cubit.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_state.dart';
import 'package:sinhala_dictionary_app/features/history/screens/history_screen.dart';
import 'package:sinhala_dictionary_app/core/widgets/delete_confirmation_dialog.dart';
import 'package:sinhala_dictionary_app/core/widgets/sort_popup_menu_button.dart';

class HistoryTabScreen extends StatefulWidget {
  final Widget drawer;
  const HistoryTabScreen({super.key, required this.drawer});

  @override
  State<HistoryTabScreen> createState() => _HistoryTabScreenState();
}

class _HistoryTabScreenState extends State<HistoryTabScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().getHistory();
  }

  Future<void> onDeletePressed() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => const DeleteConfirmationDialog(text: 'history'),
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
          title: const Text("History"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "English"),
              Tab(text: "Sinhala"),
            ],
          ),
          actions: [
            BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                final value = (state is HistoryLoaded)
                    ? state.sortBy
                    : SortOptions.latest;

                return SortPopupMenuButton(
                  value: value,
                  onSelected: context.read<HistoryCubit>().sortHistory,
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
            HistoryScreen(language: DictionaryLanguage.english),
            HistoryScreen(language: DictionaryLanguage.sinhala),
          ],
        ),
      ),
    );
  }
}
