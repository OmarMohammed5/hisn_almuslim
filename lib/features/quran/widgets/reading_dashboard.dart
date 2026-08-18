// lib/features/quran/widgets/reading_dashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routing/app_routes.dart';
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
          return _buildEmptyState(context, isDark);
        }

        final latestEntry = allHighlights.entries.reduce(
              (a, b) => a.value.timestamp > b.value.timestamp ? a : b,
        );

        final keyParts = latestEntry.key.split('_');
        if (keyParts.length != 2) {
          return _buildEmptyState(context, isDark);
        }

        final surahNumber = int.tryParse(keyParts[0]) ?? 0;
        final ayahNumber = int.tryParse(keyParts[1]) ?? 0;

        return BlocBuilder<QuranCubit, QuranState>(
          builder: (context, quranState) {
            if (quranState is! QuranLoaded) {
              return _buildLoadingState(context, isDark);
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

            // حساب رقم الصفحة والجزء والحزب
            final pageNumber = _getPageNumber(surahNumber, ayahNumber);
            final juzNumber = _getJuzNumber(surahNumber, ayahNumber);
            final hizbNumber = _getHizbNumber(surahNumber, ayahNumber);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '📖 آخر قراءة',
                          style: TextStyle(
                            fontFamily: 'Noon',
                            fontSize: 14.sp,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _getTimeAgo(latestEntry.value.timestamp),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          surah.displayName,
                          style: TextStyle(
                            fontFamily: 'Noon',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'آية $ayahNumber',
                          style: TextStyle(
                            fontFamily: 'Noon',
                            fontSize: 14.sp,
                            color: Colors.amber[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 10.h),
                  //
                  // Row(
                  //   children: [
                  //     _buildDetailItem(
                  //       icon: Icons.book,
                  //       label: 'صفحة',
                  //       value: '$pageNumber',
                  //       isDark: isDark,
                  //     ),
                  //     _buildDetailItem(
                  //       icon: Icons.format_list_numbered,
                  //       label: 'جزء',
                  //       value: '$juzNumber',
                  //       isDark: isDark,
                  //     ),
                  //     _buildDetailItem(
                  //       icon: Icons.pie_chart,
                  //       label: 'حزب',
                  //       value: '$hizbNumber',
                  //       isDark: isDark,
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 12.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.quranSurah,
                          arguments: {
                            'surahNumber': surahNumber,
                            'initialAyahNumber': ayahNumber,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.green[700] : Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'متابعة القراءة',
                            style: TextStyle(
                              fontFamily: 'Noon',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward, size: 20.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 40.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            'لا توجد قراءات سابقة',
            style: TextStyle(
              fontFamily: 'Noon',
              fontSize: 16.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'ابدأ بتظليل الآيات لتتبع قراءتك',
            style: TextStyle(
              fontFamily: 'Noon',
              fontSize: 12.sp,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // دوال مساعدة لحساب رقم الصفحة والجزء والحزب
  int _getPageNumber(int surahNumber, int ayahNumber) {
    const Map<int, int> surahStartPage = {
      1: 1, 2: 2, 3: 50, 4: 77, 5: 106, 6: 128, 7: 151, 8: 177, 9: 187,
      10: 208, 11: 221, 12: 235, 13: 249, 14: 255, 15: 262, 16: 267,
      17: 282, 18: 293, 19: 305, 20: 312, 21: 322, 22: 332, 23: 342,
      24: 350, 25: 359, 26: 367, 27: 377, 28: 385, 29: 396, 30: 404,
      31: 411, 32: 415, 33: 418, 34: 428, 35: 434, 36: 440, 37: 446,
      38: 453, 39: 458, 40: 467, 41: 477, 42: 483, 43: 489, 44: 496,
      45: 499, 46: 502, 47: 507, 48: 511, 49: 515, 50: 518, 51: 520,
      52: 523, 53: 526, 54: 528, 55: 531, 56: 534, 57: 537, 58: 542,
      59: 545, 60: 548, 61: 551, 62: 553, 63: 554, 64: 556, 65: 558,
      66: 560, 67: 562, 68: 564, 69: 566, 70: 568, 71: 570, 72: 572,
      73: 574, 74: 575, 75: 577, 76: 578, 77: 580, 78: 582, 79: 583,
      80: 585, 81: 586, 82: 587, 83: 588, 84: 589, 85: 590, 86: 591,
      87: 592, 88: 593, 89: 594, 90: 595, 91: 596, 92: 597, 93: 598,
      94: 599, 95: 600, 96: 601, 97: 602, 98: 603, 99: 604, 100: 605,
      101: 606, 102: 607, 103: 608, 104: 609, 105: 610, 106: 611,
      107: 612, 108: 613, 109: 614, 110: 615, 111: 616, 112: 617,
      113: 618, 114: 619,
    };
    return surahStartPage[surahNumber] ?? 1;
  }

  int _getJuzNumber(int surahNumber, int ayahNumber) {
    const List<Map<String, int>> juzBoundaries = [
      {'surah': 1, 'ayah': 1},
      {'surah': 2, 'ayah': 142},
      {'surah': 2, 'ayah': 253},
      {'surah': 3, 'ayah': 93},
      {'surah': 4, 'ayah': 24},
      {'surah': 4, 'ayah': 148},
      {'surah': 5, 'ayah': 82},
      {'surah': 6, 'ayah': 111},
      {'surah': 7, 'ayah': 88},
      {'surah': 8, 'ayah': 41},
      {'surah': 9, 'ayah': 93},
      {'surah': 11, 'ayah': 6},
      {'surah': 12, 'ayah': 53},
      {'surah': 15, 'ayah': 1},
      {'surah': 17, 'ayah': 1},
      {'surah': 18, 'ayah': 75},
      {'surah': 20, 'ayah': 135},
      {'surah': 23, 'ayah': 1},
      {'surah': 25, 'ayah': 21},
      {'surah': 27, 'ayah': 56},
      {'surah': 29, 'ayah': 46},
      {'surah': 33, 'ayah': 31},
      {'surah': 36, 'ayah': 28},
      {'surah': 39, 'ayah': 32},
      {'surah': 41, 'ayah': 47},
      {'surah': 46, 'ayah': 1},
      {'surah': 51, 'ayah': 31},
      {'surah': 58, 'ayah': 1},
      {'surah': 67, 'ayah': 1},
      {'surah': 78, 'ayah': 1},
    ];

    for (int i = juzBoundaries.length - 1; i >= 0; i--) {
      final boundary = juzBoundaries[i];
      if (surahNumber > boundary['surah']! ||
          (surahNumber == boundary['surah']! && ayahNumber >= boundary['ayah']!)) {
        return i + 1;
      }
    }
    return 1;
  }

  int _getHizbNumber(int surahNumber, int ayahNumber) {
    final juz = _getJuzNumber(surahNumber, ayahNumber);
    return ((juz - 1) * 2) + 1;
  }

  String _getTimeAgo(int timestamp) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}