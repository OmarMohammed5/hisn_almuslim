import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/reciter_model.dart';

class ReciterSelectorButton extends StatefulWidget {
  final ReciterModel? currentReciter;
  final List<ReciterModel> reciters;
  final Function(ReciterModel) onReciterSelected;

  const ReciterSelectorButton({
    super.key,
    required this.currentReciter,
    required this.reciters,
    required this.onReciterSelected,
  });

  @override
  State<ReciterSelectorButton> createState() => _ReciterSelectorButtonState();
}

class _ReciterSelectorButtonState extends State<ReciterSelectorButton> {
  // Search Logic of Reciters — unchanged.
  final TextEditingController _searchReciterController =
  TextEditingController();
  late List<ReciterModel> _filteredReciters = widget.reciters;

  void _searchReciters(String keyWord) {
    setState(() {
      final input = keyWord.trim().toLowerCase();
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
  void initState() {
    _filteredReciters = widget.reciters;
    super.initState();
  }

  @override
  void dispose() {
    _searchReciterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xff1f242a) : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color badgeBg = isDark
        ? AppColors.kPrimary.withValues(alpha: 0.18)
        : AppColors.kPrimarySoft;
    final Color mutedIconBg = isDark
        ? AppColors.kPrimary.withValues(alpha: 0.18)
        : AppColors.kPrimarySoft;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      elevation: 0,
      child: InkWell(
        onTap: _showReciterSelectionDialog,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.10),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
          child: Row(
            children: [
              _ReciterAvatar(
                hasReciter: widget.currentReciter != null,
                isDark: isDark,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: CustomText(
                            'القارئ الشيخ',
                            color: AppColors.kPrimary,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CustomText(
                      widget.currentReciter?.reciter.ar ?? 'اختر القارئ',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      maxLines: 1,
                    ),
                    if (widget.currentReciter != null)
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 11.sp,
                            color: AppColors.kTextMuted,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: CustomText(
                              "رواية ${widget.currentReciter!.rewaya.ar}",
                              maxLines: 1,
                              fontSize: 10.sp,
                              color: AppColors.kTextMuted,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: mutedIconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_vert_rounded,
                  color: AppColors.kPrimary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReciterSelectionDialog() {
    // Captured once from the page context — the modal sheet below
    // reuses this so it never has to guess the theme on its own.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color sheetBg = isDark ? const Color(0xff1a1f24) : Colors.white;
    final Color handleColor =
    isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey.shade300;
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.35,
            maxChildSize: 0.92,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: sheetBg,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
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
                        controller: _searchReciterController,
                        onChanged: (value) {
                          _searchReciters(value);
                          setModalState(() {});
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
                          suffixIcon: _searchReciterController.text.isNotEmpty
                              ? GestureDetector(
                            onTap: () {
                              _searchReciterController.clear();
                              _searchReciters('');
                              setModalState(() {});
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
                            borderSide:
                            BorderSide(color: AppColors.kIconColor, width: 1.5),
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
        },
      ),
    );
  }
}

class _ReciterAvatar extends StatelessWidget {
  final bool hasReciter;
  final bool isDark;

  const _ReciterAvatar({required this.hasReciter, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final Color mutedIconBg = isDark
        ? AppColors.kPrimary.withValues(alpha: 0.18)
        : AppColors.kPrimarySoft;
    return Container(
      width: 46.w,
      height: 46.w,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
       color: mutedIconBg,
      ),
      child: Icon(
        hasReciter ? Icons.headphones_rounded : Icons.person_search_rounded,
        color: AppColors.kIconColor,
        size: 20,
      ),
    );
  }
}