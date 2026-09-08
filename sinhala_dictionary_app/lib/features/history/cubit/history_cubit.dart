import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_state.dart';
import 'package:sinhala_dictionary_app/features/history/repository/history_repository.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository repository;
  HistoryCubit(this.repository) : super(HistoryInitial());

  Future<void> getHistory({SortOptions sortBy = .latest}) async {
    final history = await Future.wait([
      repository.getHistory(DictionaryLanguage.english, sortBy: sortBy),
      repository.getHistory(DictionaryLanguage.sinhala, sortBy: sortBy),
    ]);

    emit(
      HistoryLoaded(
        englishHistory: history[0],
        sinhalaHistory: history[1],
        sortBy: sortBy,
      ),
    );
  }

  Future<void> sortHistory(SortOptions sortBy) async {
    await getHistory(sortBy: sortBy);
  }

  Future<void> clearHistory() async {
    await repository.deleteHistory();
    await getHistory();
  }
}
