import 'package:flutter/material.dart';
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
        ? Colors.grey.shade900.withValues(alpha: 0.6)
        : Colors.white;

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

    final radius = BorderRadius.circular(20.r);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
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
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Modern Header with Progress =====
                Row(
                  children: [
                    // Surah Number Circle with Gradient
                    Container(
                      width: 44.w,
                      height: 44.w,
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Noon',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),

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
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: mainText,
                                    fontFamily: 'Noon',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Reading Status Badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_arrow_rounded,
                                      size: 12.sp,
                                      color: primary,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'متابعة',
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w600,
                                        color: primary,
                                        fontFamily: 'Noon',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: LinearProgressIndicator(
                                    value: ayahNumber / 286, // Approximate progress
                                    backgroundColor: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      primary.withValues(alpha: 0.8),
                                    ),
                                    minHeight: 4.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '$_getProgress%',
                                style: TextStyle(
                                  fontSize: 10.sp,
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

                SizedBox(height: 16.h),

                // ===== Reading Stats Grid =====
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.3)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade700.withValues(alpha: 0.2)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildStatItem(
                        icon: Icons.menu_book_rounded,
                        value: '$pageNumber',
                        label: 'صفحة',
                        primary: primary,
                        isDark: isDark,
                      ),
                      _buildDivider(isDark),
                      _buildStatItem(
                        icon: Icons.auto_stories_rounded,
                        value: '$juzNumber',
                        label: 'جزء',
                        primary: primary,
                        isDark: isDark,
                      ),
                      _buildDivider(isDark),
                      _buildStatItem(
                        icon: Icons.layers_rounded,
                        value: '$hizbNumber',
                        label: 'حزب',
                        primary: primary,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // ===== Last Reading Time =====
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: secondaryText,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'آخر قراءة :  ${_getTimeAgo(timestamp)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: secondaryText,
                        fontFamily: 'Noon',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    // Continue Reading Button
                    Container(
                      height: 32.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            primary,
                            primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _goToSurah(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'متابعة',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Noon',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14.sp,
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

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color primary,
    required bool isDark,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: primary.withValues(alpha: 0.7),
              ),
              SizedBox(width: 6.w),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.grey.shade800,
                  fontFamily: 'Noon',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
              fontFamily: 'Noon',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 30.h,
      color: isDark
          ? Colors.grey.shade700.withValues(alpha: 0.3)
          : Colors.grey.shade300.withValues(alpha: 0.5),
    );
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