import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HadithCard extends StatelessWidget {
  final String content;
  final int index;
  final double fontSize;
  final String searchQuery;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const HadithCard({
    super.key,
    required this.content,
    required this.index,
    required this.fontSize,
    this.searchQuery = '',
    this.onCopy,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
      child: Stack(
        children: [
          // Main Card
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Ornamental Border
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOrnament(isDark),
                  ],
                ),
                Gap(12.h),

                // Header with Index
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIndexBadge(index, isDark),
                    Row(
                      children: [
                        _buildIconButton(Icons.copy_rounded, onCopy, isDark),
                        Gap(8.w),
                        _buildIconButton(Icons.share_rounded, onShare, isDark),
                      ],
                    ),
                  ],
                ),
                Gap(16.h),

                // Hadith Content
                _buildHighlightedText(
                  context,
                  content.trim(),
                  searchQuery,
                  fontSize.sp,
                ),
                Gap(16.h),

                // Bottom Ornamental Border
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOrnament(isDark),
                  ],
                ),
              ],
            ),
          ),

          // Decorative corner accents
          Positioned(
            top: -4.h,
            left: -4.w,
            child: _buildCornerAccent(isDark),
          ),
          Positioned(
            top: -4.h,
            right: -4.w,
            child: _buildCornerAccent(isDark),
          ),
          Positioned(
            bottom: -4.h,
            left: -4.w,
            child: _buildCornerAccent(isDark),
          ),
          Positioned(
            bottom: -4.h,
            right: -4.w,
            child: _buildCornerAccent(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildOrnament(bool isDark) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 2.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                isDark ? Colors.teal.shade600 : Colors.teal.shade400,
              ],
            ),
          ),
        ),
        Gap(8.w),
        Icon(
          Icons.dark_mode_outlined,
          size: 14.sp,
          color: isDark ? Colors.teal.shade600 : Colors.teal.shade400,
        ),
        Gap(8.w),
        Container(
          width: 30.w,
          height: 2.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDark ? Colors.teal.shade600 : Colors.teal.shade400,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndexBadge(int index, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade400,
            Colors.teal.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 14.sp,
            color: Colors.white,
          ),
          Gap(6.w),
          Text(
            'حديث ${index + 1}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Cairo",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback? onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCornerAccent(bool isDark) {
    return Container(
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.teal.shade800 : Colors.teal.shade100,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  Widget _buildHighlightedText(
      BuildContext context,
      String text,
      String query,
      double fontSize,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (query.isEmpty) {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          height: 2.4.h,
          fontFamily: "Uthmani",
          color: isDark ? Colors.white : Color(0xFF1A1A2E),
          letterSpacing: 0.8,
          wordSpacing: 2,
        ),
      );
    }

    final spans = _buildHighlightSpans(text, query, context, fontSize);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          height: 2.4.h,
          fontFamily: "Uthmani",
          color: isDark ? Colors.white : Color(0xFF1A1A2E),
          letterSpacing: 0.8,
          wordSpacing: 2,
        ),
        children: spans,
      ),
    );
  }

  List<TextSpan> _buildHighlightSpans(
      String text,
      String query,
      BuildContext context,
      double fontSize,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: TextStyle(
            backgroundColor: isDark
                ? Colors.tealAccent.withValues(alpha: 0.2)
                : Colors.amber.withValues(alpha: 0.3),
            color: isDark ? Colors.tealAccent : Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: fontSize * 1.1,
          ),
        ),
      );

      start = index + query.length;
    }
    return spans;
  }
}