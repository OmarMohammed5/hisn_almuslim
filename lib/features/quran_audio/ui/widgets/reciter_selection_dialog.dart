import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/responsive/app_responsive.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';

class ReciterSelectionDialog extends StatefulWidget {
  final ReciterModel? currentReciter;
  final List<ReciterModel> reciters;
  final Function(ReciterModel) onReciterSelected;

  const ReciterSelectionDialog({
    super.key,
    required this.currentReciter,
    required this.reciters,
    required this.onReciterSelected,
  });

  @override
  State<ReciterSelectionDialog> createState() => _ReciterSelectionDialogState();
}

class _ReciterSelectionDialogState extends State<ReciterSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  late List<ReciterModel> _filteredReciters;

  @override
  void initState() {
    super.initState();
    _filteredReciters = widget.reciters;
  }

  void _searchReciters(String keyword) {
    setState(() {
      final input = keyword.trim().toLowerCase();
      if (input.isEmpty) {
        _filteredReciters = widget.reciters;
      } else {
        _filteredReciters = widget.reciters
            .where(
              (reciter) => reciter.reciter.ar.toLowerCase().contains(input),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color sheetBg = isDark ? const Color(0xff1a1f24) : Colors.white;
    final Color handleColor = isDark
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.grey.shade300;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color fieldFill = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : AppColors.kPrimarySoft.withValues(alpha: 0.4);
    final Color hintColor = isDark ? Colors.white38 : Colors.grey.shade400;
    final Color unselectedTileBg = isDark
        ? const Color(0xff23282e)
        : Colors.grey.shade50;
    final Color unselectedAvatarBg = isDark
        ? const Color(0xff2d3338)
        : Colors.white;
    final Color unselectedAvatarText = isDark ? Colors.white70 : Colors.black54;
    final Color unselectedNameText = isDark ? Colors.white : Colors.black87;
    final Color rewayaText = isDark ? Colors.white54 : Colors.grey.shade600;
    final Color emptyIconColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final Color emptyTextColor = isDark ? Colors.white54 : Colors.grey.shade600;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppResponsive.radius(context, 28)),
              ),
            ),
            child: Column(
              children: [
                Gap(AppResponsive.heightValue(context, 14)),

                Container(
                  width: AppResponsive.widthValue(context, 44),
                  height: AppResponsive.heightValue(context, 5),
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Gap(AppResponsive.heightValue(context, 16)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.widthValue(context, 20),
                    0,
                    AppResponsive.widthValue(context, 20),
                    AppResponsive.heightValue(context, 4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          AppResponsive.radius(context, 8),
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.kPrimary.withValues(alpha: 0.18)
                              : AppColors.kPrimarySoft,
                          borderRadius: BorderRadius.circular(
                            AppResponsive.radius(context, 12),
                          ),
                        ),
                        child: Icon(
                          Icons.record_voice_over_rounded,
                          color: AppColors.kPrimary,
                          size: AppResponsive.iconSize(context, 18),
                        ),
                      ),
                      Gap(AppResponsive.widthValue(context, 10)),
                      CustomText(
                        'اختر القارئ',
                        fontSize: AppResponsive.fontSize(context, 14),
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                      const Spacer(),
                      CustomText(
                        '${widget.reciters.length} قارئ',
                        fontSize: AppResponsive.fontSize(context, 10.5),
                        color: AppColors.kTextMuted,
                      ),
                    ],
                  ),
                ),
                Gap(AppResponsive.heightValue(context, 16)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.widthValue(context, 16),
                  ),
                  child: TextField(
                    cursorColor: AppColors.kIconColor,
                    style: TextStyle(color: titleColor),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: _searchController,
                    onChanged: (value) {
                      _searchReciters(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث في القراء ...',
                      hintStyle: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 11),
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.w500,
                        color: hintColor,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: hintColor,
                        size: AppResponsive.iconSize(context, 20),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _searchReciters('');
                              },
                              child: Icon(
                                CupertinoIcons.clear,
                                size: AppResponsive.iconSize(context, 18),
                                color: hintColor,
                              ),
                            )
                          : const SizedBox.shrink(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 14),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 14),
                        ),
                        borderSide: BorderSide(
                          color: AppColors.kIconColor,
                          width: AppResponsive.heightValue(context, 1.5),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: AppResponsive.heightValue(context, 10),
                      ),
                      filled: true,
                      fillColor: fieldFill,
                    ),
                  ),
                ),
                Gap(AppResponsive.heightValue(context, 14)),
                Expanded(
                  child: _filteredReciters.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: AppResponsive.iconSize(context, 35),
                                color: emptyIconColor,
                              ),
                              Gap(AppResponsive.heightValue(context, 8)),
                              CustomText(
                                'لا يوجد قراء بهذا الاسم',
                                color: emptyTextColor,
                                fontSize: AppResponsive.fontSize(context, 12),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.widthValue(context, 12),
                            vertical: AppResponsive.heightValue(context, 8),
                          ),
                          itemCount: _filteredReciters.length,
                          separatorBuilder: (_, __) =>
                              Gap(AppResponsive.heightValue(context, 6)),
                          itemBuilder: (context, index) {
                            final reciter = _filteredReciters[index];
                            final isSelected =
                                widget.currentReciter?.id == reciter.id;
                            final originalIndex = widget.reciters.indexWhere(
                              (r) => r.id == reciter.id,
                            );
                            final displayNumber = originalIndex + 1;

                            return Material(
                              color: isSelected
                                  ? (isDark
                                        ? AppColors.kPrimary.withValues(
                                            alpha: 0.18,
                                          )
                                        : AppColors.kPrimaryLight)
                                  : unselectedTileBg,
                              borderRadius: BorderRadius.circular(
                                AppResponsive.radius(context, 16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  AppResponsive.radius(context, 16),
                                ),
                                onTap: () {
                                  widget.onReciterSelected(reciter);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppResponsive.widthValue(
                                      context,
                                      12,
                                    ),
                                    vertical: AppResponsive.heightValue(
                                      context,
                                      10,
                                    ),
                                  ),
                                  child: Row(
                                    spacing: AppResponsive.widthValue(
                                      context,
                                      12,
                                    ),
                                    children: [
                                      CircleAvatar(
                                        radius: AppResponsive.radius(
                                          context,
                                          19,
                                        ),
                                        backgroundColor: isSelected
                                            ? AppColors.kPrimary
                                            : unselectedAvatarBg,
                                        child: Text(
                                          '$displayNumber',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : unselectedAvatarText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppResponsive.fontSize(
                                              context,
                                              13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: AppResponsive.heightValue(
                                            context,
                                            6,
                                          ),
                                          children: [
                                            CustomText(
                                              reciter.reciter.ar,
                                              maxLines: 1,
                                              fontWeight: FontWeight.w600,
                                              fontSize: AppResponsive.fontSize(
                                                context,
                                                12,
                                              ),
                                              color: isSelected
                                                  ? AppColors.kPrimary
                                                  : unselectedNameText,
                                            ),
                                            CustomText(
                                              reciter.rewaya.ar,
                                              fontSize: AppResponsive.fontSize(
                                                context,
                                                10,
                                              ),
                                              color: rewayaText,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.kPrimary,
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
      },
    );
  }
}

void showReciterSelectionDialog(
  BuildContext context, {
  required ReciterModel? currentReciter,
  required List<ReciterModel> reciters,
  required Function(ReciterModel) onReciterSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(
      minWidth: double.infinity,
      maxWidth: double.infinity,
    ),
    builder: (context) => SizedBox(
      width: double.infinity,
      child: ReciterSelectionDialog(
        currentReciter: currentReciter,
        reciters: reciters,
        onReciterSelected: onReciterSelected,
      ),
    ),
  );
}
