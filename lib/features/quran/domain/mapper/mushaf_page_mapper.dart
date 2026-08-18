// lib/features/quran/domain/mapper/mushaf_page_mapper.dart

import '../entities/ayah_entity.dart';
import '../entities/mushaf_page_entity.dart';
import '../entities/mushaf_page_group_entity.dart';
import '../entities/surah_entity.dart';


class MushafPageMapper {
  const MushafPageMapper._();

  static MushafPageGroupEntity mapSurahToPages(SurahEntity surah) {
    if (surah.ayahs.isEmpty) {
      return MushafPageGroupEntity(surahNumber: surah.number, pages: const []);
    }

    final List<MushafPageEntity> pages = [];
    List<AyahEntity> currentPageAyahs = [];
    int? currentPageNumber;

    for (final ayah in surah.ayahs) {
      if (currentPageNumber == null) {
        currentPageNumber = ayah.page;
      }

      if (ayah.page != currentPageNumber) {
        // Flush the completed page before starting a new one.
        pages.add(_buildPage(
          ayahs: currentPageAyahs,
          surahNumber: surah.number,
          surahName: surah.displayName,
        ));

        currentPageAyahs = [];
        currentPageNumber = ayah.page;
      }

      currentPageAyahs.add(ayah);
    }

    // Flush the last page.
    if (currentPageAyahs.isNotEmpty) {
      pages.add(_buildPage(
        ayahs: currentPageAyahs,
        surahNumber: surah.number,
        surahName: surah.displayName,
      ));
    }

    return MushafPageGroupEntity(surahNumber: surah.number, pages: pages);
  }

  static MushafPageEntity _buildPage({
    required List<AyahEntity> ayahs,
    required int surahNumber,
    required String surahName,
  }) {
    final first = ayahs.first;
    return MushafPageEntity(
      pageNumber: first.page,
      juz: first.juz,
      hizbQuarter: first.hizbQuarter,
      surahNumber: surahNumber,
      surahName: surahName,
      ayahs: List.unmodifiable(ayahs),
    );
  }
}