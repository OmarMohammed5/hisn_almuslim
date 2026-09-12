import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/responsive/app_responsive.dart';
import '../../../core/theme/app_colors.dart';

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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 4),
        vertical: AppResponsive.heightValue(context, 10),
      ),
      child: Stack(
        children: [
          // Main Card
          Container(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: borderColor,
                width: AppResponsive.widthValue(context, 1),
              ),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Ornamental Border
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildOrnament(context, isDark)],
                ),
                Gap(AppResponsive.heightValue(context, 16)),

                // Header with Index
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIndexBadge(context, index, isDark),
                    Row(
                      children: [
                        _buildIconButton(
                          context,
                          Icons.copy_rounded,
                          onCopy,
                          isDark,
                        ),
                        Gap(AppResponsive.widthValue(context, 8)),
                        _buildIconButton(
                          context,
                          Icons.share_rounded,
                          onShare,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(AppResponsive.heightValue(context, 16)),

                // Hadith Content
                _buildHighlightedText(
                  context,
                  content.trim(),
                  searchQuery,
                  fontSize,
                ),
                Gap(AppResponsive.heightValue(context, 16)),

                // Bottom Ornamental Border
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildOrnament(context, isDark)],
                ),
              ],
            ),
          ),

          // Decorative corner accents
          Positioned(
            top: AppResponsive.heightValue(context, -4),
            left: AppResponsive.widthValue(context, -4),
            child: _buildCornerAccent(context, isDark),
          ),
          Positioned(
            top: AppResponsive.heightValue(context, -4),
            right: AppResponsive.widthValue(context, -4),
            child: _buildCornerAccent(context, isDark),
          ),
          Positioned(
            bottom: AppResponsive.heightValue(context, -4),
            left: AppResponsive.widthValue(context, -4),
            child: _buildCornerAccent(context, isDark),
          ),
          Positioned(
            bottom: AppResponsive.heightValue(context, -4),
            right: AppResponsive.widthValue(context, -4),
            child: _buildCornerAccent(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildOrnament(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          width: AppResponsive.widthValue(context, 30),
          height: AppResponsive.heightValue(context, 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                isDark ? Colors.teal.shade600 : Colors.teal.shade400,
              ],
            ),
          ),
        ),
        Gap(AppResponsive.widthValue(context, 8)),
        Icon(
          Icons.dark_mode_outlined,
          size: AppResponsive.iconSize(context, 14),
          color: isDark ? Colors.teal.shade600 : Colors.teal.shade400,
        ),
        Gap(AppResponsive.widthValue(context, 8)),
        Container(
          width: AppResponsive.widthValue(context, 30),
          height: AppResponsive.heightValue(context, 2),
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

  Widget _buildIndexBadge(BuildContext context, int index, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 12),
        vertical: AppResponsive.heightValue(context, 4),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
        ),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: AppResponsive.iconSize(context, 14),
            color: Colors.white,
          ),
          Gap(AppResponsive.widthValue(context, 6)),
          Text(
            'حديث ${index + 1}',
            style: TextStyle(
              color: Colors.white,
              fontSize: AppResponsive.fontSize(context, 12),
              fontWeight: FontWeight.w600,
              fontFamily: "Cairo",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback? onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: AppResponsive.iconSize(context, 18),
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCornerAccent(BuildContext context, bool isDark) {
    return Container(
      width: AppResponsive.widthValue(context, 16),
      height: AppResponsive.heightValue(context, 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.teal.shade800 : Colors.teal.shade100,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 4)),
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
          height: AppResponsive.heightValue(context, 2.3),
          fontFamily: "Noon",
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
          height: AppResponsive.heightValue(context, 2.3),
          fontFamily: "Noon",
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
