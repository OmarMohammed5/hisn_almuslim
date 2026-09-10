import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
      bottom: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .75,
        ),

        decoration: BoxDecoration(
          color: bg,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppResponsive.radius(context, 28)),
          ),
        ),

        child: Column(
          children: [
            SizedBox(height: AppResponsive.heightValue(context, 10)),

            Container(
              width: AppResponsive.widthValue(context, 38),
              height: AppResponsive.heightValue(context, 4),

              decoration: BoxDecoration(
                color: muted.withValues(alpha: .25),

                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 20),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.widthValue(context, 20),
                vertical: AppResponsive.heightValue(context, 17),
              ),

              child: CustomText(
                'اختر نمط القراءة',
                color: text,
                fontSize: AppResponsive.fontSize(context, 14),
                fontWeight: FontWeight.w700,
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.widthValue(context, 16),
                  0,
                  AppResponsive.widthValue(context, 16),
                  AppResponsive.heightValue(context, 25),
                ),

                physics: const BouncingScrollPhysics(),

                itemCount: quranReadingModes.length,

                separatorBuilder: (_, __) =>
                    SizedBox(height: AppResponsive.heightValue(context, 8)),

                itemBuilder: (context, index) {
                  final item = quranReadingModes[index];

                  final isSelected = item.mode == selected;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),

                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary.withValues(alpha: .08)
                          : surface,

                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 17),
                      ),

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

                      borderRadius: BorderRadius.circular(
                        AppResponsive.radius(context, 17),
                      ),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppResponsive.widthValue(context, 14),
                          vertical: AppResponsive.heightValue(context, 13),
                        ),

                        child: Row(
                          children: [
                            Container(
                              width: AppResponsive.widthValue(context, 43),
                              height: AppResponsive.widthValue(context, 43),

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary.withValues(alpha: .10)
                                    : muted.withValues(alpha: .07),

                                borderRadius: BorderRadius.circular(
                                  AppResponsive.radius(context, 13),
                                ),
                              ),

                              child: Icon(
                                item.icon,

                                color: isSelected ? primary : muted,

                                size: AppResponsive.fontSize(context, 21),
                              ),
                            ),

                            SizedBox(
                              width: AppResponsive.widthValue(context, 12),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  CustomText(
                                    item.title,
                                    color: text,
                                    fontSize: AppResponsive.fontSize(
                                      context,
                                      13,
                                    ),
                                    fontWeight: FontWeight.w700,
                                  ),

                                  SizedBox(
                                    height: AppResponsive.heightValue(
                                      context,
                                      7,
                                    ),
                                  ),

                                  CustomText(
                                    item.subtitle,
                                    color: muted,
                                    fontSize: AppResponsive.fontSize(
                                      context,
                                      10,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 160),

                              child: isSelected
                                  ? Container(
                                      key: const ValueKey('selected'),

                                      width: AppResponsive.widthValue(
                                        context,
                                        25,
                                      ),

                                      height: AppResponsive.widthValue(
                                        context,
                                        25,
                                      ),

                                      decoration: BoxDecoration(
                                        color: primary,

                                        shape: BoxShape.circle,
                                      ),

                                      child: Icon(
                                        Icons.check_rounded,

                                        color: darkMode
                                            ? const Color(0xFF10201A)
                                            : Colors.white,

                                        size: AppResponsive.fontSize(
                                          context,
                                          15,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      key: const ValueKey('empty'),

                                      width: AppResponsive.widthValue(
                                        context,
                                        18,
                                      ),

                                      height: AppResponsive.widthValue(
                                        context,
                                        18,
                                      ),

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

          ],
        ),
      ),
    );
  }
}
