import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LectureSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isSearching;
  final bool showClear;

  const LectureSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.isSearching,
    required this.showClear,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.10)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        onChanged: onChanged,
        style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'ابحث عن محاضرة، موضوع، أو شيخ...',
          hintStyle: TextStyle(
            fontSize: 12.5.sp,
            color: scheme.onSurface.withValues(alpha: 0.45),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              Icons.search_rounded,
              color: scheme.primary,
              size: 20.sp,
            ),
          ),
          suffixIcon: isSearching
              ? Padding(
            padding: EdgeInsets.all(14.w),
            child: SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.primary,
              ),
            ),
          )
              : showClear
              ? IconButton(
            onPressed: onClear,
            icon: Icon(
              Icons.close_rounded,
              size: 19.sp,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}