import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisn_almuslim/features/quran/widgets/dashboard_card.dart';
import '../../../core/utils/quran_utils.dart';
import '../data/cubit/ayah_highlight_cubit.dart';
import '../data/cubit/ayah_highlight_state.dart';
import '../data/cubit/quran_cubit.dart';
import '../data/cubit/quran_state.dart';
import '../domain/entities/surah_entity.dart';

class ReadingDashboard extends StatelessWidget {
  const ReadingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AyahHighlightCubit, AyahHighlightState>(
      builder: (context, highlightState) {
        final allHighlights = highlightState.highlights;

        if (allHighlights.isEmpty) {
          return buildEmptyState(context, isDark);
        }

        final latestEntry = allHighlights.entries.reduce(
          (a, b) => a.value.timestamp > b.value.timestamp ? a : b,
        );

        final keyParts = latestEntry.key.split('_');

        if (keyParts.length != 2) {
          return buildEmptyState(context, isDark);
        }

        final surahNumber = int.tryParse(keyParts[0]) ?? 0;

        final ayahNumber = int.tryParse(keyParts[1]) ?? 0;

        return BlocBuilder<QuranCubit, QuranState>(
          builder: (context, quranState) {
            if (quranState is! QuranLoaded) {
              return buildLoadingState(context, isDark);
            }

            final surah = quranState.surahs.firstWhere(
              (s) => s.number == surahNumber,
              orElse: () => SurahEntity(
                number: surahNumber,
                name: 'غير معروف',
                nameSimplified: 'غير معروف',
                englishName: 'Unknown',
                englishNameTranslation: 'Unknown',
                revelationType: 'meccan',
                surahInfo: null,
                surahInfoFromBook: null,
                surahNames: null,
                surahNamesFromBook: null,
                ayahs: [],
              ),
            );

            final pageNumber = getPageNumber(surahNumber, ayahNumber);

            final juzNumber = getJuzNumber(surahNumber, ayahNumber);

            final hizbNumber = _getHizbNumber(surahNumber, ayahNumber);

            return DashboardCard(
              isDark: isDark,
              surah: surah,
              surahNumber: surahNumber,
              ayahNumber: ayahNumber,
              pageNumber: pageNumber,
              juzNumber: juzNumber,
              hizbNumber: hizbNumber,
              timestamp: latestEntry.value.timestamp,
            );
          },
        );
      },
    );
  }

  // Hizb Number
  int _getHizbNumber(int surahNumber, int ayahNumber) {
    final juz = getJuzNumber(surahNumber, ayahNumber);

    return ((juz - 1) * 2) + 1;
  }
}
