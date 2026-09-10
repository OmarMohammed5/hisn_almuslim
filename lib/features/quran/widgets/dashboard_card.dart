import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../domain/entities/surah_entity.dart';

class DashboardCard extends StatelessWidget {
  final SurahEntity surah;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final int juzNumber;
  final int hizbNumber;
  final int timestamp;

  const DashboardCard({
    super.key,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.kPrimary;

    // Modern color scheme
    final cardBg = isDark
        ? Colors.grey.shade900.withValues(alpha: 0.2)
        : Colors.white;

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;


    final borderColor = isDark
        ? Colors.grey.shade700.withValues(alpha: 0.3)
        : Colors.grey.shade200;

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.grey.shade300.withValues(alpha: 0.5);

    final mainText = isDark ? Colors.white : Colors.grey.shade900;
    final secondaryText = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    final radius = BorderRadius.circular(AppResponsive.radius(context, 20));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 16), vertical: AppResponsive.heightValue(context, 6)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: AppResponsive.radius(context, 20),
            offset: Offset(0, AppResponsive.heightValue(context, 8)),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: radius,
          onTap: () => _goToSurah(context),
          splashColor: primary.withValues(alpha: 0.1),
          highlightColor: primary.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Modern Header with Progress =====
                Row(
                  children: [
                    // Surah Number Circle with Gradient
                    Container(
                      width: AppResponsive.widthValue(context, 32),
                      height: AppResponsive.widthValue(context, 32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primary,
                            primary.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$surahNumber',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 14),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Noon',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppResponsive.widthValue(context, 14)),

                    // Surah Name & Progress
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  surah.displayName,
                                  style: TextStyle(
                                    fontSize: AppResponsive.fontSize(context, 14),
                                    fontWeight: FontWeight.w700,
                                    color: mainText,
                                    fontFamily: 'Noon',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppResponsive.heightValue(context, 4)),
                          // Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 4)),
                                  child: LinearProgressIndicator(
                                    value: ayahNumber / 286, // Approximate progress
                                    backgroundColor: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      primary.withValues(alpha: 0.8),
                                    ),
                                    minHeight: AppResponsive.heightValue(context, 4),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppResponsive.widthValue(context, 10)),
                              Text(
                                '$_getProgress%',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 10),
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                  fontFamily: 'Noon',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppResponsive.heightValue(context, 13)),

                // ===== Last Reading Time =====
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: AppResponsive.fontSize(context, 14),
                      color: secondaryText,
                    ),
                    SizedBox(width: AppResponsive.widthValue(context, 6)),
                    Text(
                      'آخر قراءة :  ${_getTimeAgo(timestamp)}',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 11),
                        color: secondaryText,
                        fontFamily: 'Noon',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    // Continue Reading Button
                    Container(
                      height: AppResponsive.heightValue(context, 32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            primary,
                            primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _goToSurah(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 16)),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'متابعة',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 11),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Noon',
                              ),
                            ),
                            SizedBox(width: AppResponsive.widthValue(context, 4)),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: AppResponsive.fontSize(context, 14),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int get _getProgress {
    return ((ayahNumber / 286) * 100).round().clamp(0, 100);
  }



  void _goToSurah(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.quranSurah,
      arguments: {'surahNumber': surahNumber, 'initialAyahNumber': ayahNumber},
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
}