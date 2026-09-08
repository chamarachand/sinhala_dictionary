import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:sinhala_dictionary_app/core/enums/ai_language.dart';
import 'package:sinhala_dictionary_app/features/ai_insights/cubit/ai_insights_cubit.dart';
import 'package:sinhala_dictionary_app/features/ai_insights/cubit/ai_insights_state.dart';

class AiInsightsScreen extends StatefulWidget {
  final String targetWord;

  const AiInsightsScreen({super.key, required this.targetWord});

  @override
  State<AiInsightsScreen> createState() => _AiInsightsScreenState();
}

class _AiInsightsScreenState extends State<AiInsightsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AiInsightsCubit>().getAiInsights(word: widget.targetWord);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiInsightsCubit, AiInsightsState>(
      builder: (context, state) {
        return Column(
          children: [
            LanguagePill(state: state, targetWord: widget.targetWord),
            if (state is AiInsightsLoading)
              const Expanded(
                child: Center(
                  child: Text(
                    "Thinking...",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else if (state is AiInsightsError)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: .center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AiInsightsCubit>().getAiInsights(
                            word: widget.targetWord,
                          );
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              )
            else if (state is AiInsightsLoaded)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MarkdownBody(
                      data: state.insights,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        h3: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 2.2,
                        ),
                        p: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

class LanguagePill extends StatelessWidget {
  final String targetWord;
  final AiInsightsState state;
  const LanguagePill({
    super.key,
    required this.state,
    required this.targetWord,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SegmentedButton<AiLanguage>(
          segments: const [
            ButtonSegment(value: AiLanguage.english, label: Text('English')),
            ButtonSegment(value: AiLanguage.sinhala, label: Text('සිංහල')),
          ],
          selected: {state.language},
          onSelectionChanged: (selected) {
            context.read<AiInsightsCubit>().changeLanguage(
              word: targetWord,
              newLanguage: selected.first,
            );
          },
          showSelectedIcon: false,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            side: WidgetStateProperty.all(BorderSide.none),
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primaryContainer;
              }
              return colorScheme.surfaceContainerHighest.withOpacity(0.5);
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.onPrimaryContainer;
              }
              return colorScheme.onSurfaceVariant;
            }),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            ),
          ),
        ),
      ],
    );
  }
}
