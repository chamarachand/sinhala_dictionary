import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/features/search/cubit/search_cubit.dart';
import 'package:sinhala_dictionary_app/features/search/cubit/search_state.dart';
import 'package:sinhala_dictionary_app/features/search/widgets/dictionary_search_bar.dart';
import 'package:sinhala_dictionary_app/features/search/widgets/language_direction_toggle.dart';
import 'package:sinhala_dictionary_app/features/search/widgets/word_item.dart';
import 'package:sinhala_dictionary_app/features/word_details/screens/word_detail_tab_screen.dart';

class SearchScreen extends StatefulWidget {
  final Widget drawer;
  const SearchScreen({super.key, required this.drawer});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isEnglishToSinhala = true;

  void _toggleLanguageDirection() {
    setState(() => _isEnglishToSinhala = !_isEnglishToSinhala);
  }

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hela Dictionary")),
      drawer: widget.drawer,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LanguageDirectionToggle(
                isEnglishToSinhala: _isEnglishToSinhala,
                onTap: _toggleLanguageDirection,
              ),

              const SizedBox(height: 12),

              DictionarySearchBar(
                onChanged: (value) {
                  if (value.trim().isEmpty) return;

                  context.read<SearchCubit>().searchWords(
                    query: value,
                    isEnglishToSinhala: _isEnglishToSinhala,
                  );
                },
                onReset: () => context.read<SearchCubit>().reset(),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchIntial) {
                      return const Center(
                        child: Text('Start typing to look up meanings!'),
                      );
                    }

                    if (state is SearchEmpty) {
                      return const Center(child: Text('No definitions found.'));
                    }

                    if (state is SearchLoaded) {
                      return ListView.builder(
                        itemCount: state.results.length,
                        itemBuilder: (context, index) {
                          final item = state.results[index];

                          return WordItem(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WordDetailTabScreen(
                                    wordData: item,
                                    showAiInsightsTab: _isEnglishToSinhala,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
