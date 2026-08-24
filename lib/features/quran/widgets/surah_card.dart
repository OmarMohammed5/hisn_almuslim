import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../domain/entities/surah_entity.dart';

class SurahCard extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onTap;
  final double progress;

  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    this.progress = 0.0,
  });

  // ============================================================
  // Mushaf / Quran Palette
  // ============================================================

  static const Color _lightText =
  Color(0xFF292C29);

  static const Color _darkText =
  Color(0xFFE8E0CC);

  static const Color _lightTeal =
  Color(0xFF16877D);

  static const Color _darkTeal =
  Color(0xFF66C7BB);

  static const Color _lightGold =
  Color(0xFFB59A5A);

  static const Color _darkGold =
  Color(0xFFCDB878);

  static const Color _lightCard =
  Color(0xFFFFFCF5);

  static const Color _darkCard =
  Color(0xFF202724);

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final isMeccan =
        surah.isMeccan;

    final accentColor =
    isDark
        ? _darkTeal
        : _lightTeal;

    final goldColor =
    isDark
        ? _darkGold
        : _lightGold;

    final textColor =
    isDark
        ? _darkText
        : _lightText;

    final cardColor =
    isDark
        ? _darkCard
        : _lightCard;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: EdgeInsets.only(
          bottom: 9.h,
        ),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius:
          BorderRadius.circular(
            18.r,
          ),

          border: Border.all(
            color: isDark
                ? Colors.white.withValues(
              alpha: 0.055,
            )
                : goldColor.withValues(
              alpha: 0.13,
            ),

            width: 0.8,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark
                    ? 0.12
                    : 0.045,
              ),

              blurRadius: 14.r,

              offset: Offset(
                0,
                5.h,
              ),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius:
          BorderRadius.circular(
            18.r,
          ),

          child: Stack(
            children: [

              // ==================================================
              // Subtle Accent Line
              // ==================================================

              Positioned(
                right: 0,
                top: 0,
                bottom: 0,

                child: Container(
                  width: 3.w,

                  decoration:
                  BoxDecoration(
                    color:
                    isMeccan
                        ? accentColor
                        : goldColor,
                  ),
                ),
              ),

              // ==================================================
              // Main Content
              // ==================================================

              Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),

                child: Row(
                  children: [

                    // ==================================================
                    // Surah Number
                    // ==================================================

                    _buildSurahNumber(
                      isDark: isDark,
                      accentColor:
                      accentColor,
                      goldColor:
                      goldColor,
                    ),

                    SizedBox(
                      width: 13.w,
                    ),

                    // ==================================================
                    // Surah Information
                    // ==================================================

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          // ------------------------------------------
                          // Surah Name
                          // ------------------------------------------

                          Text(
                            surah.displayName,

                            maxLines: 1,

                            overflow:
                            TextOverflow.ellipsis,

                            style: TextStyle(
                              fontFamily:
                              'QuranFont',

                              fontSize:
                              18.sp,

                              fontWeight:
                              FontWeight.w600,

                              color:
                              textColor,

                              height:
                              1.35,
                            ),
                          ),

                          SizedBox(
                            height: 7.h,
                          ),

                          // ------------------------------------------
                          // Metadata
                          // ------------------------------------------

                          Row(
                            children: [

                              _buildInfoChip(
                                label:
                                isMeccan
                                    ? 'مكية'
                                    : 'مدنية',



                                color:
                                isMeccan
                                    ? accentColor
                                    : goldColor,

                                isDark:
                                isDark,
                              ),

                              SizedBox(
                                width: 9.w,
                              ),

                              _buildInfoChip(
                                label:
                                '${surah.totalAyahs} آية',


                                color:
                                textColor
                                    .withValues(
                                  alpha:
                                  0.65,
                                ),

                                isDark:
                                isDark,
                              ),
                            ],
                          ),

                          // ------------------------------------------
                          // Reading Progress
                          // ------------------------------------------

                          if (progress > 0)
                            Padding(
                              padding:
                              EdgeInsets.only(
                                top: 9.h,
                              ),

                              child:
                              _buildProgress(
                                progress:
                                progress,

                                accentColor:
                                accentColor,

                                isDark:
                                isDark,
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 10.w,
                    ),

                    // ==================================================
                    // Arrow
                    // ==================================================

                    _buildArrow(
                      accentColor:
                      accentColor,
                      isDark:
                      isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Surah Number
  // ============================================================

  Widget _buildSurahNumber({
    required bool isDark,
    required Color accentColor,
    required Color goldColor,
  }) {
    final color =
    surah.isMeccan
        ? accentColor
        : goldColor;

    return SizedBox(
      width: 46.w,
      height: 46.w,

      child: Stack(
        alignment:
        Alignment.center,

        children: [

          // --------------------------------------------------------
          // Outer Diamond
          // --------------------------------------------------------

          Transform.rotate(
            angle: 0.785398,

            child: Container(
              width: 31.w,
              height: 31.w,

              decoration:
              BoxDecoration(
                color: color.withValues(
                  alpha: isDark
                      ? 0.10
                      : 0.075,
                ),

                border: Border.all(
                  color: color.withValues(
                    alpha: isDark
                        ? 0.45
                        : 0.35,
                  ),

                  width: 1.1,
                ),

                borderRadius:
                BorderRadius.circular(
                  6.r,
                ),
              ),
            ),
          ),

          // --------------------------------------------------------
          // Number
          // --------------------------------------------------------

          Text(
            '${surah.number}',

            style: TextStyle(
              fontFamily:
              'Cairo',

              fontSize:
              surah.number > 99
                  ? 10.sp
                  : 12.sp,

              fontWeight:
              FontWeight.w700,

              color:
              color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Info Chip
  // ============================================================

  Widget _buildInfoChip({
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding:
      EdgeInsets.symmetric(
        horizontal: 7.w,
        vertical: 3.5.h,
      ),

      decoration:
      BoxDecoration(
        color: color.withValues(
          alpha: isDark
              ? 0.08
              : 0.055,
        ),

        borderRadius:
        BorderRadius.circular(
          7.r,
        ),

        border: Border.all(
          color: color.withValues(
            alpha: isDark
                ? 0.13
                : 0.10,
          ),

          width: 0.6,
        ),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [


          Text(
            label,

            style: TextStyle(
              fontFamily:
              'Noon',

              fontSize:
              9.5.sp,

              fontWeight:
              FontWeight.w500,

              color:
              color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Reading Progress
  // ============================================================

  Widget _buildProgress({
    required double progress,
    required Color accentColor,
    required bool isDark,
  }) {
    final safeProgress =
    progress.clamp(0.0, 1.0);

    return Row(
      children: [

        Expanded(
          child: Container(
            height: 3.h,

            decoration:
            BoxDecoration(
              color: accentColor
                  .withValues(
                alpha: isDark
                    ? 0.10
                    : 0.08,
              ),

              borderRadius:
              BorderRadius.circular(
                10.r,
              ),
            ),

            child:
            FractionallySizedBox(
              alignment:
              Alignment.centerLeft,

              widthFactor:
              safeProgress,

              child: Container(
                decoration:
                BoxDecoration(
                  color:
                  accentColor,

                  borderRadius:
                  BorderRadius.circular(
                    10.r,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          width: 7.w,
        ),

        Text(
          '${(safeProgress * 100).round()}%',

          style: TextStyle(
            fontFamily:
            'QuranFont',

            fontSize:
            8.5.sp,

            fontWeight:
            FontWeight.w600,

            color:
            accentColor
                .withValues(
              alpha: 0.75,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Arrow
  // ============================================================

  Widget _buildArrow({
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      width: 31.w,
      height: 31.w,

      decoration:
      BoxDecoration(
        shape:
        BoxShape.circle,

        color: accentColor
            .withValues(
          alpha: isDark
              ? 0.07
              : 0.055,
        ),
      ),

      child: Icon(
        Icons
            .arrow_forward_ios_rounded,

        size: 12.sp,

        color:
        accentColor.withValues(
          alpha: 0.75,
        ),
      ),
    );
  }
}