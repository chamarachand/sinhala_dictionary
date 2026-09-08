import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/di/injection.dart';
import 'package:sinhala_dictionary_app/features/ai_insights/cubit/ai_insights_cubit.dart';
import 'package:sinhala_dictionary_app/features/favourites/repositories/favourites_repository.dart';
import 'package:sinhala_dictionary_app/features/history/repository/history_repository.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';
import 'package:sinhala_dictionary_app/features/word_details/widgets/word_banner.dart';
import 'package:sinhala_dictionary_app/features/ai_insights/screens/ai_insights_screen.dart';
import 'package:sinhala_dictionary_app/features/word_details/screens/dictionary_tab_view.dart';

class WordDetailTabScreen extends StatefulWidget {
  final WordDefinition wordData;
  final bool showAiInsightsTab;

  const WordDetailTabScreen({
    super.key,
    required this.wordData,
    this.showAiInsightsTab = true,
  });

  @override
  State<WordDetailTabScreen> createState() => _WordDetailTabScreenState();
}

class _WordDetailTabScreenState extends State<WordDetailTabScreen> {
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _checkFavouriteStatus();
    _saveToHistory();
  }

  Future<void> _checkFavouriteStatus() async {
    final favRepo = getIt<FavouritesRepository>();
    final status = await favRepo.checkIsFavourite(widget.wordData.id);

    setState(() => _isFavourite = status);
  }

  Future<void> _saveToHistory() async {
    final historyRepo = getIt<HistoryRepository>();
    await historyRepo.saveToHistory(widget.wordData.id);
  }

  Future<void> _toggleFavourite() async {
    setState(() => _isFavourite = !_isFavourite); // Optimistic UI update

    final favRepo = getIt<FavouritesRepository>();
    favRepo.toggleFavourite(widget.wordData.id);
  }

  @override
  Widget build(BuildContext context) {
    final String targetWord = widget.wordData.word;
    final String rawDefinition = widget.wordData.definition;
    final bool isEnglish = widget.wordData.isEnglish;

    final List<String> definitionsList = rawDefinition
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    // 1. Dynamic length check
    final int tabCount = isEnglish ? 2 : 1;

    return DefaultTabController(
      length: tabCount, // Updated dynamically
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Word Definition'),
          actions: [
            IconButton(
              icon: Icon(
                _isFavourite ? Icons.favorite : Icons.favorite_border,
                color: _isFavourite ? Colors.redAccent : null,
              ),
              onPressed: () => _toggleFavourite(),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PINNED HEADER CARD VIEW ---
              WordBanner(wordData: widget.wordData),

              const SizedBox(height: 16),

              // 2. Wrap TabBar in a conditional or dynamic list
              TabBar(
                tabs: [
                  const Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, size: 18),
                        SizedBox(width: 8),
                        Text("Dictionary"),
                      ],
                    ),
                  ),
                  if (isEnglish) // Dynamic Tab Item
                    const Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome_outlined, size: 18),
                          SizedBox(width: 8),
                          Text("AI Insights"),
                        ],
                      ),
                    ),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              const SizedBox(height: 16),

              // --- DYNAMIC SWITCHING CONTENT VIEW ---
              Expanded(
                child: BlocProvider(
                  create: (_) => getIt<AiInsightsCubit>(),
                  child: TabBarView(
                    children: [
                      DictionaryTabView(definitionsList: definitionsList),
                      if (isEnglish) AiInsightsScreen(targetWord: targetWord),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
