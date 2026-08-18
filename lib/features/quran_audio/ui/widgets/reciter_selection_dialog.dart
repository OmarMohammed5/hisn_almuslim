import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            .where((reciter) => reciter.reciter.ar.toLowerCase().contains(input))
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
    final Color unselectedTileBg =
    isDark ? const Color(0xff23282e) : Colors.grey.shade50;
    final Color unselectedAvatarBg =
    isDark ? const Color(0xff2d3338) : Colors.white;
    final Color unselectedAvatarText =
    isDark ? Colors.white70 : Colors.black54;
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
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: Column(
            children: [
              Gap(14.h),
              Container(
                width: 44.w,
                height: 4.5.h,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Gap(16.h),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 4.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.kPrimary.withValues(alpha: 0.18)
                            : AppColors.kPrimarySoft,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.record_voice_over_rounded,
                        color: AppColors.kPrimary,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    CustomText(
                      'اختر القارئ',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                    const Spacer(),
                    CustomText(
                      '${widget.reciters.length} قارئ',
                      fontSize: 10.5.sp,
                      color: AppColors.kTextMuted,
                    ),
                  ],
                ),
              ),
              Gap(16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                      fontSize: 11.sp,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.w500,
                      color: hintColor,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: hintColor,
                      size: 20.sp,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _searchReciters('');
                      },
                      child: Icon(
                        CupertinoIcons.clear,
                        size: 18,
                        color: hintColor,
                      ),
                    )
                        : const SizedBox.shrink(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(
                        color: AppColors.kIconColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    filled: true,
                    fillColor: fieldFill,
                  ),
                ),
              ),
              Gap(14.h),
              Expanded(
                child: _filteredReciters.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 36,
                        color: emptyIconColor,
                      ),
                      Gap(8.h),
                      CustomText(
                        'لا يوجد قراء بهذا الاسم',
                        color: emptyTextColor,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
                )
                    : ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  itemCount: _filteredReciters.length,
                  separatorBuilder: (_, __) => Gap(6.h),
                  itemBuilder: (context, index) {
                    final reciter = _filteredReciters[index];
                    final isSelected =
                        widget.currentReciter?.id == reciter.id;
                    final originalIndex = widget.reciters
                        .indexWhere((r) => r.id == reciter.id);
                    final displayNumber = originalIndex + 1;

                    return Material(
                      color: isSelected
                          ? (isDark
                          ? AppColors.kPrimary.withValues(alpha: 0.18)
                          : AppColors.kPrimaryLight)
                          : unselectedTileBg,
                      borderRadius: BorderRadius.circular(16.r),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () {
                          widget.onReciterSelected(reciter);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            spacing: 12.w,
                            children: [
                              CircleAvatar(
                                radius: 19,
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
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  spacing: 6.h,
                                  children: [
                                    CustomText(
                                      reciter.reciter.ar,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: isSelected
                                          ? AppColors.kPrimary
                                          : unselectedNameText,
                                    ),
                                    CustomText(
                                      reciter.rewaya.ar,
                                      fontSize: 10.sp,
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
    builder: (context) => ReciterSelectionDialog(
      currentReciter: currentReciter,
      reciters: reciters,
      onReciterSelected: onReciterSelected,
    ),
  );
}