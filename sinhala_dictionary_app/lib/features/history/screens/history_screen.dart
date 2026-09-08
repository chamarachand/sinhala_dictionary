import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_cubit.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_state.dart';
import 'package:sinhala_dictionary_app/features/search/widgets/word_item.dart';
import 'package:sinhala_dictionary_app/features/word_details/screens/word_detail_tab_screen.dart';

class HistoryScreen extends StatelessWidget {
  final DictionaryLanguage language;
  const HistoryScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryLoaded) {
              final history = (language == DictionaryLanguage.english)
                  ? state.englishHistory
                  : state.sinhalaHistory;

              if (history.isEmpty) {
                return const Center(child: Text('No history found.'));
              }

              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];

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
                      context.read<HistoryCubit>().getHistory();
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
