import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/quran/widgets/build_info_item.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/shared/custom_text.dart';
import '../domain/entities/surah_entity.dart';

class DashboardCard extends StatelessWidget {
  final bool isDark;

  final SurahEntity surah;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final int hizbNumber;
  final int timestamp;

  const DashboardCard({
    super.key,
    required this.isDark,
    required this.surah,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.hizbNumber,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.kPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? const Color(0xFF0C2421)
        : const Color(0xFFEAF7F4);

    final cardGradient = isDark
        ? const [Color(0xFF123D38), Color(0xFF0C2926)]
        : const [Color(0xFFF3FBF9), Color(0xFFE3F4F0)];

    final mainText = isDark ? Colors.white : const Color(0xFF123330);

    final secondaryText = isDark
        ? Colors.white.withValues(alpha: .62)
        : const Color(0xFF466965);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: cardGradient,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: primary.withValues(alpha: isDark ? .20 : .14),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: isDark ? .07 : .08),
            blurRadius: 22.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -55.h,
              left: -40.w,
              child: _buildDecorationCircle(
                size: 140.w,
                color: primary.withValues(alpha: isDark ? .055 : .07),
              ),
            ),



            /// Continue Reading
            Positioned(
              left: 18.w,
              top: 50.h,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quranSurah,
                      arguments: {
                        'surahNumber': surahNumber,
                        'initialAyahNumber': ayahNumber,
                      },
                    );
                  },
                  child: Container(
                    height: 37.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(
                            alpha: isDark ? .20 : .16,
                          ),
                          blurRadius: 12.r,
                          offset: Offset(0, 5.h),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          'متابعة القراءة',
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),

                        SizedBox(width: 7.w),

                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 35.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withValues(alpha: isDark ? .14 : .10),
                          border: Border.all(
                            color: primary.withValues(alpha: .18),
                          ),
                        ),
                        child: Icon(
                          FlutterIslamicIcons.solidQuran2,
                          color: primary,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'آخر قراءة',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Noon',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: mainText,
                              ),
                            ),

                            SizedBox(height: 2.h),

                            Text(
                              _getTimeAgo(timestamp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Noon',
                                fontSize: 10.sp,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Ayah badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: isDark ? .13 : .09),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: primary.withValues(alpha: .15),
                          ),
                        ),
                        child: CustomText(
                          'آية $ayahNumber',
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: primary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Surah Information
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Container(
                           width: 38.w,
                           height: 38.w,
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             color: primary.withValues(alpha: isDark ? .10 : .08),
                             border: Border.all(
                               color: primary.withValues(alpha: .16),
                             ),
                           ),
                           child: Center(
                             child: CustomText(
                               '$surahNumber',
                               fontSize: 13.sp,
                               fontWeight: FontWeight.w900,
                               color: primary,
                             ),
                           ),
                         ),

                         SizedBox(width: 12.w),

                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               CustomText(
                                 surah.displayName,
                                 fontSize: 18.sp,
                                 fontWeight: FontWeight.w900,
                                 color: mainText,
                               ),

                               SizedBox(height: 4.h),

                               CustomText(
                                 'متابعة من الآية $ayahNumber',
                                 maxLines: 1,
                                 fontSize: 11.sp,
                                 color: secondaryText,
                               ),
                             ],
                           ),
                         ),

                       ],
                     ),


                  SizedBox(height: 18.h),

                  // Reading Info
                  Row(
                    children: [
                      Expanded(
                        child: BuildInfoItem(
                          icon: Icons.menu_book_rounded,
                          value: '$pageNumber',
                          label: 'صفحة',
                          primary: primary,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: BuildInfoItem(
                          icon: Icons.auto_stories_rounded,
                          value: '$juzNumber',
                          label: 'جزء',
                          primary: primary,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: BuildInfoItem(
                          icon: Icons.layers_rounded,
                          value: '$hizbNumber',
                          label: 'حزب',
                          primary: primary,
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildDecorationCircle({required double size, required Color color}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
