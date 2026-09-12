import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/responsive/app_responsive.dart';

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
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.10)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: AppResponsive.fontSize(context, 13.5),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن محاضرة، موضوع، أو شيخ...',
          hintStyle: TextStyle(
            fontSize: AppResponsive.fontSize(context, 12.5),
            color: scheme.onSurface.withValues(alpha: 0.45),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
            child: Icon(
              Icons.search_rounded,
              color: scheme.primary,
              size: AppResponsive.fontSize(context, 20),
            ),
          ),
          suffixIcon: isSearching
              ? Padding(
                  padding: EdgeInsets.all(
                    AppResponsive.widthValue(context, 14),
                  ),
                  child: SizedBox(
                    width: AppResponsive.widthValue(context, 16),
                    height: AppResponsive.widthValue(context, 16),
                    child: CupertinoActivityIndicator(color: scheme.primary),
                  ),
                )
              : showClear
              ? IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close_rounded,
                    size: AppResponsive.fontSize(context, 19),
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: AppResponsive.heightValue(context, 14),
          ),
        ),
      ),
    );
  }
}
