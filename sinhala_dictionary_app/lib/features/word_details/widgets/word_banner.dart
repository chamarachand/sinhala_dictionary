import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sinhala_dictionary_app/features/search/data/word_definition.dart';

class WordBanner extends StatefulWidget {
  final WordDefinition wordData;
  const WordBanner({super.key, required this.wordData});

  @override
  State<WordBanner> createState() => _WordBannerState();
}

class _WordBannerState extends State<WordBanner> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  void _initTTS() {
    _flutterTts.setStartHandler(() => setState(() => _isPlaying = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isPlaying = false));
    _flutterTts.setErrorHandler((msg) => setState(() => _isPlaying = false));
  }

  Future<void> _speak() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      return;
    }

    final word = widget.wordData.word;
    final isEnglishToSinhala = widget.wordData.isEnglish;

    if (isEnglishToSinhala) {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.45);
    } else {
      await _flutterTts.setLanguage("si-LK");
      await _flutterTts.setSpeechRate(0.5);
    }

    if (word.isNotEmpty) {
      await _flutterTts.speak(word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withAlpha(120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wordData.word,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withAlpha(150),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Noun", // Change later
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              padding: const EdgeInsets.all(12),
              onPressed: _speak,
              icon: Icon(
                _isPlaying ? Icons.volume_up : Icons.volume_mute,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
