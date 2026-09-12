import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../routing/app_routes.dart';

int getPageNumber(int surahNumber, int ayahNumber) {
  const Map<int, int> surahStartPage = {
    1: 1,
    2: 2,
    3: 50,
    4: 77,
    5: 106,
    6: 128,
    7: 151,
    8: 177,
    9: 187,
    10: 208,
    11: 221,
    12: 235,
    13: 249,
    14: 255,
    15: 262,
    16: 267,
    17: 282,
    18: 293,
    19: 305,
    20: 312,
    21: 322,
    22: 332,
    23: 342,
    24: 350,
    25: 359,
    26: 367,
    27: 377,
    28: 385,
    29: 396,
    30: 404,
    31: 411,
    32: 415,
    33: 418,
    34: 428,
    35: 434,
    36: 440,
    37: 446,
    38: 453,
    39: 458,
    40: 467,
    41: 477,
    42: 483,
    43: 489,
    44: 496,
    45: 499,
    46: 502,
    47: 507,
    48: 511,
    49: 515,
    50: 518,
    51: 520,
    52: 523,
    53: 526,
    54: 528,
    55: 531,
    56: 534,
    57: 537,
    58: 542,
    59: 545,
    60: 548,
    61: 551,
    62: 553,
    63: 554,
    64: 556,
    65: 558,
    66: 560,
    67: 562,
    68: 564,
    69: 566,
    70: 568,
    71: 570,
    72: 572,
    73: 574,
    74: 575,
    75: 577,
    76: 578,
    77: 580,
    78: 582,
    79: 583,
    80: 585,
    81: 586,
    82: 587,
    83: 588,
    84: 589,
    85: 590,
    86: 591,
    87: 592,
    88: 593,
    89: 594,
    90: 595,
    91: 596,
    92: 597,
    93: 598,
    94: 599,
    95: 600,
    96: 601,
    97: 602,
    98: 603,
    99: 604,
    100: 605,
    101: 606,
    102: 607,
    103: 608,
    104: 609,
    105: 610,
    106: 611,
    107: 612,
    108: 613,
    109: 614,
    110: 615,
    111: 616,
    112: 617,
    113: 618,
    114: 619,
  };
  return surahStartPage[surahNumber] ?? 1;
}

int getJuzNumber(int surahNumber, int ayahNumber) {
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
        (surahNumber == boundary['surah']! &&
            ayahNumber >= boundary['ayah']!)) {
      return i + 1;
    }
  }

  return 1;
}

Widget buildEmptyState(BuildContext context, bool isDark) {
  final theme = Theme.of(context);
  final primary = theme.colorScheme.primary;
  final scheme = theme.colorScheme;

  // --- Adaptive Colors ---
  final titleColor = isDark ? Colors.white : const Color(0xFF183A36);
  final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
  final borderColor = isDark
      ? Colors.white.withValues(alpha: 0.07)
      : AppColors.kBorderLight;

  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppResponsive.widthValue(context, 16),
      vertical: AppResponsive.heightValue(context, 6),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: AppResponsive.widthValue(context, 14),
      vertical: AppResponsive.heightValue(context, 14),
    ),
    decoration: BoxDecoration(
      color: bgColor,
      border: Border.all(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: .20)
              : primary.withValues(alpha: .06),
          blurRadius: AppResponsive.radius(context, 16),
          offset: Offset(0, AppResponsive.heightValue(context, 4)),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          width: AppResponsive.widthValue(context, 50),
          height: AppResponsive.widthValue(context, 50),
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 3)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.kPrimary,
                AppColors.kPrimary.withValues(alpha: 0.35),
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.kSurfaceDark : Colors.white,
            ),
            child: Icon(
              FlutterIslamicIcons.solidQuran2,
              size: AppResponsive.iconSize(context, 22),
              color: isDark ? Colors.white : AppColors.kPrimary,
            ),
          ),
        ),

        Gap(AppResponsive.widthValue(context, 12)),

        Expanded(
          child: CustomText(
            "قم بتظليل آخر ما قرأت لتسجيل تقدمك",
            fontSize: AppResponsive.fontSize(context, 11),
            maxLines: 3,
            fontWeight: FontWeight.w700,
            color: titleColor,
            height: 1.4,
          ),
        ),

        Gap(AppResponsive.widthValue(context, 10)),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 30)),
            boxShadow: [
              BoxShadow(
                color: AppColors.kPrimary.withValues(alpha: isDark ? 0.3 : 0.25),
                blurRadius: AppResponsive.radius(context, 10),
                offset: Offset(0, AppResponsive.heightValue(context, 3)),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.quranHome);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.widthValue(context, 14),
                vertical: AppResponsive.heightValue(context, 10),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 30),
                ),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  'افتح المصحف',
                  fontSize: AppResponsive.fontSize(context, 10),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  maxLines: 1,
                ),
                Gap(AppResponsive.widthValue(context, 5)),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: AppResponsive.iconSize(context, 14),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Loading
Widget buildLoadingState(BuildContext context, bool isDark) {
  final primary = Theme.of(context).colorScheme.primary;

  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: AppResponsive.widthValue(context, 16),
      vertical: AppResponsive.heightValue(context, 8),
    ),
    height: AppResponsive.heightValue(context, 230),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF101F1D) : Colors.white,
      borderRadius: BorderRadius.circular(AppResponsive.radius(context, 22)),
      border: Border.all(color: primary.withValues(alpha: .08)),
    ),
    child: Center(
      child: SizedBox(
        width: AppResponsive.widthValue(context, 24),
        height: AppResponsive.heightValue(context, 24),
        child: CupertinoActivityIndicator(color: primary),
      ),
    ),
  );
}
