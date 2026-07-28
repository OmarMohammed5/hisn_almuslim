import 'package:flutter/material.dart';
import 'package:hisn_almuslim/features/quran_audio/data/models/surah_audio_model.dart';
import '../../data/models/reciter_model.dart';

/// Widget displaying surah and reciter information
class AudioPlayerInfo extends StatelessWidget {
  final SurahAudioModel surah;
  final ReciterModel reciter;

  const AudioPlayerInfo({
    super.key,
    required this.surah,
    required this.reciter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Surah number with circular background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${surah.number}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Surah names
        Text(
          surah.nameArabic,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          surah.nameEnglish,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Divider
        Divider(color: Theme.of(context).colorScheme.outlineVariant),
        const SizedBox(height: 16),
        // Reciter info
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              reciter.reciter.en,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          reciter.rewaya.en,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
