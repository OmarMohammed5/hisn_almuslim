import 'package:equatable/equatable.dart';

import 'mushaf_page_entity.dart';


class MushafPageGroupEntity extends Equatable {
  final int surahNumber;
  final List<MushafPageEntity> pages;

  const MushafPageGroupEntity({
    required this.surahNumber,
    required this.pages,
  });

  int get totalPages => pages.length;

  MushafPageEntity? pageContainingAyah(int ayahNumberInSurah) {
    for (final page in pages) {
      if (ayahNumberInSurah >= page.firstAyahNumberInSurah &&
          ayahNumberInSurah <= page.lastAyahNumberInSurah) {
        return page;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [surahNumber, pages];
}