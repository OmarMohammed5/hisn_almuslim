import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/quran/data/cubit/quran_cubit.dart';
import 'package:hisn_almuslim/features/quran/data/models/last_page_storage.dart';
import 'package:hisn_almuslim/features/quran/screen/surah_screen.dart';
import 'package:hisn_almuslim/features/quran/widgets/quran_dashboard.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class BuildProgressState extends StatelessWidget {
  const BuildProgressState({
    super.key,
    required int lastPage,
    required String surahName,
    required this.widget,
    required this.context,
    required this.isDark,
  }) : _lastPage = lastPage,
       _surahName = surahName;

  final int _lastPage;
  final String _surahName;
  final QuranProgressDashboard widget;
  final BuildContext context;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = _lastPage / 604;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Color(0xff1c2227), Color(0xff111518)]
              : [Colors.white, Color(0xfff7fffd)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1.3.w),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            children: [
              Icon(
                FlutterIslamicIcons.quran2,
                color: Colors.teal.shade700,
                size: 22.sp,
              ),
              Gap(8.w),
              Text(
                'القرآن الكريم',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontFamily: "Noon",
                ),
              ),
            ],
          ),
          // Surah Name & Surah Page & Achivement (Circle Progress Indicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Surah Name
              Column(
                spacing: 10.h,
                children: [
                  Text(
                    _surahName,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Noon",
                    ),
                  ),
                  CustomText(
                    'صفحة $_lastPage من 604',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),

              // Circle Progress Indicator
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, _) {
                  return SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 90.h,
                          width: 90.h,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8.w,
                            backgroundColor: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.teal.shade700,
                            ),
                          ),
                        ),
                        CustomText(
                          '${(value * 100).toStringAsFixed(0)}%',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade500,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          // Button to Continue the Reading and Navigator to Surah Screen
          _lastPage < 604
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async {
                      // To come the last page
                      final lastPage = await LastPageStorage.loadPage();
                      int surahIndex = 0;
                      for (int i = widget.surahs.length - 1; i >= 0; i--) {
                        if (widget.surahs[i].startPage <= lastPage) {
                          surahIndex = i;
                          break;
                        }
                      }

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SurahScreen(
                              surahIndex: surahIndex,
                              initialPage: lastPage,
                            ); // Pass surahindex to navigate to the last surah
                          },
                        ),
                      );
                      if (context.mounted) {
                        // ignore: use_build_context_synchronously
                        context.read<QuranCubit>().loadSurahs();
                      }
                    },
                    child: Container(
                      // margin: EdgeInsets.only(right: 75.w, left: 75.w),
                      width: 122.w,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade600,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4.w,
                        children: [
                          CustomText(
                            'متابعة القراءة',
                            fontSize: 11.sp,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 13.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
