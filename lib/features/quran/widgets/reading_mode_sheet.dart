import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/quran/widgets/reader_settings.dart';
import '../../../core/shared/custom_text.dart';

class ReadingModeSheet extends StatelessWidget {
  final QuranReadingMode selected;
  final bool darkMode;

  final ValueChanged<QuranReadingMode> onSelected;

  const ReadingModeSheet({
    super.key,
    required this.selected,
    required this.darkMode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bg = darkMode ? const Color(0xFF101815) : const Color(0xFFF7F4EC);

    final surface = darkMode
        ? const Color(0xFF171F1B)
        : const Color(0xFFFDFBF5);

    final text = darkMode ? const Color(0xFFECE6D6) : const Color(0xFF20281F);

    final muted = darkMode ? const Color(0xFF8E9A92) : const Color(0xFF7B837C);

    final primary = darkMode
        ? const Color(0xFF7EB6A8)
        : const Color(0xFF1F5145);

    final gold = darkMode ? const Color(0xFFD2B57C) : const Color(0xFFAC8E54);

    return SafeArea(
      top: false,

      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .75,
        ),

        decoration: BoxDecoration(
          color: bg,

          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),

        child: Column(
          children: [
            SizedBox(height: 10.h),

            Container(
              width: 38.w,
              height: 4.h,

              decoration: BoxDecoration(
                color: muted.withValues(alpha: .25),

                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),

              child: CustomText(
                'اختر نمط القراءة',
                color: text,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 25.h),

                physics: const BouncingScrollPhysics(),

                itemCount: quranReadingModes.length,

                separatorBuilder: (_, __) => SizedBox(height: 8.h),

                itemBuilder: (context, index) {
                  final item = quranReadingModes[index];

                  final isSelected = item.mode == selected;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary.withValues(alpha: .08)
                          : surface,

                      borderRadius: BorderRadius.circular(17.r),

                      border: Border.all(
                        color: isSelected
                            ? primary.withValues(alpha: .55)
                            : Colors.transparent,
                      ),
                    ),

                    child: InkWell(
                      onTap: () {
                        onSelected(item.mode);

                        Navigator.pop(context);
                      },

                      borderRadius: BorderRadius.circular(17.r),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 13.h,
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: 43.w,
                              height: 43.w,

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary.withValues(alpha: .10)
                                    : muted.withValues(alpha: .07),

                                borderRadius: BorderRadius.circular(13.r),
                              ),

                              child: Icon(
                                item.icon,

                                color: isSelected ? primary : muted,

                                size: 21.sp,
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  CustomText(
                                    item.title,
                                    color: text,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                  ),

                                  SizedBox(height: 7.h),

                                  CustomText(
                                    item.subtitle,
                                    color: muted,
                                    fontSize: 10.sp,
                                  ),
                                ],
                              ),
                            ),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 160),

                              child: isSelected
                                  ? Container(
                                      key: const ValueKey('selected'),

                                      width: 25.w,

                                      height: 25.w,

                                      decoration: BoxDecoration(
                                        color: primary,

                                        shape: BoxShape.circle,
                                      ),

                                      child: Icon(
                                        Icons.check_rounded,

                                        color: darkMode
                                            ? const Color(0xFF10201A)
                                            : Colors.white,

                                        size: 15.sp,
                                      ),
                                    )
                                  : Container(
                                      key: const ValueKey('empty'),

                                      width: 18.w,

                                      height: 18.w,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        border: Border.all(
                                          color: muted.withValues(alpha: .45),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 18.h),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.auto_awesome_rounded, size: 14.sp, color: gold),

                  SizedBox(width: 6.w),

                  CustomText(
                    'يمكن تغيير النمط في أي وقت',
                    color: muted,
                    fontSize: 9.5.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
