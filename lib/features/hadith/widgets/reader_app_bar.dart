import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class ReaderAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final String title;
  final int count;
  final int filteredCount;
  final bool isFiltered;
  final Function()? onUiVisible;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggle;
  final void Function()? onFontTap;
  final bool isUiVisible;
  final int currentPage;

  const ReaderAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.title,
    required this.onSearchChanged,
    required this.onSearchToggle,
    this.onFontTap,
    required this.count,
    required this.filteredCount,
    required this.isFiltered,
    this.onUiVisible,
    required this.isUiVisible,
    required this.currentPage,
  });

  @override
  State<ReaderAppBar> createState() => _ReaderAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}

class _ReaderAppBarState extends State<ReaderAppBar> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onUiVisible,
      child: AppBar(
        toolbarHeight: 80.h,
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        // Leading: Back button
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.sp,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        // Title section
        title: widget.isSearching
            ? _buildSearchField(isDark)
            : _buildTitleSection(isDark),

        // Actions
        actions: [
          _buildActionButton(
            icon: widget.isSearching ? Icons.close : Icons.search,
            onPressed: widget.onSearchToggle,
            isDark: isDark,
          ),
          Gap(8.w),
          _buildActionButton(
            icon: Icons.text_fields,
            onPressed: widget.onFontTap,
            isDark: isDark,
            color: Colors.teal,
          ),
          Gap(12.w),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.teal.withOpacity(0.3), width: 1),
      ),
      child: TextField(
        controller: widget.searchController,
        autofocus: true,
        cursorColor: Colors.teal,
        style: TextStyle(
          fontFamily: "Cairo",
          fontSize: 14.sp,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: "ابحث في الأحاديث ...",
          hintStyle: TextStyle(
            fontFamily: "Cairo",
            fontSize: 11.5.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          prefixIcon: Icon(Icons.search, color: Colors.teal, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        onChanged: widget.onSearchChanged,
      ),
    );
  }

  Widget _buildTitleSection(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: "Uthmani",
            color: isDark ? Colors.white : Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        Gap(6.h),

        // Count or Page indicator
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.isUiVisible
              ? _buildPageIndicator(isDark)
              : _buildCountBadge(isDark),
        ),
      ],
    );
  }

  Widget _buildCountBadge(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CustomText(
        widget.isFiltered
            ? 'النتائج: ${widget.filteredCount} من أصل ${widget.count}'
            : 'عدد الأحاديث: ${widget.count}',
        fontSize: 11.sp,
        color: Colors.teal[700]!,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPageIndicator(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 14.sp, color: Colors.teal),
          Gap(6.w),
          Text(
            "${widget.currentPage + 1} / ${widget.count}",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDark,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            color?.withOpacity(0.1) ??
            (isDark ? Colors.grey[850] : Colors.grey[100]),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20.sp,
          color: color ?? (isDark ? Colors.white : Colors.black87),
        ),
        onPressed: onPressed,
        padding: EdgeInsets.all(8.w),
        constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
      ),
    );
  }
}
