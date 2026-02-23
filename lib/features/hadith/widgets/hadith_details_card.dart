import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/features/hadith/widgets/header_card.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [Color(0xff1a1f24), Color(0xff252b31)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? Colors.teal.withOpacity(0.2)
              : Colors.teal.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.teal.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderCard(index: index, onCopy: onCopy, onShare: onShare),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Decorative divider
                Container(
                  height: 3.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.teal.shade200],
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                SizedBox(height: 16.h),

                _buildHighlightedText(
                  context,
                  content,
                  searchQuery,
                  fontSize.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===== Highlighted Text =====
  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    String query,
    double fontSize,
  ) {
    if (query.isEmpty) {
      return Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: fontSize.sp,
          height: 2.0.h,
          fontFamily: "Uthmani",
          color: _baseTextColor(context),
          letterSpacing: 0.3,
        ),
      );
    }

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
            backgroundColor: _highlightBackground(context),
            color: _highlightTextColor(context),
            fontWeight: FontWeight.bold,
            // borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      );

      start = index + query.length;
    }

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize.sp,
          height: 2.0.h,
          fontFamily: "Uthmani",
          color: _baseTextColor(context),
          letterSpacing: 0.3,
        ),
        children: spans,
      ),
    );
  }

  Color _baseTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white.withOpacity(0.95) : Colors.black87;
  }

  Color _highlightBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Colors.tealAccent.withOpacity(0.3)
        : Colors.amber.withOpacity(0.4);
  }

  Color _highlightTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.black : Colors.black87;
  }
}
