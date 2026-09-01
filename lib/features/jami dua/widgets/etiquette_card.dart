import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/jami%20dua/data/models/etiquette_item.dart';

class EtiquetteCard extends StatefulWidget {
  final EtiquetteItem item;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final double fontSize;

  const EtiquetteCard({
    super.key,
    required this.item,
    required this.onCopy,
    required this.onShare,
    required this.fontSize,
  });

  @override
  State<EtiquetteCard> createState() => _EtiquetteCardState();
}

class _EtiquetteCardState extends State<EtiquetteCard> {
  bool _showHadith = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _CustomActionButton(
                icon: Icons.copy,
                label: 'نسخ',
                onTap: widget.onCopy,
                isDark: isDark,
              ),
              Gap(12.w),
              _CustomActionButton(
                icon: Icons.share_outlined,
                label: 'مشاركة',
                onTap: widget.onShare,
                isDark: isDark,
              ),
            ],
          ),

          Gap(12.h),

          Divider(
            height: 1.h,
            color: isDark ? Colors.white12 : Colors.black12,
            thickness: 1,
          ),

          Gap(16.h),

          Text(
            widget.item.arabic,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Noon',
              fontSize: widget.fontSize.sp,
              height: 1.8.h,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A),
            ),
          ),

          Gap(12.h),

          Row(
            children: [
              Icon(Icons.bookmark_border, size: 16.sp, color: Colors.grey.shade600),
              Gap(6.w),
              Text(
                widget.item.reference,
                style: TextStyle(
                  fontFamily: 'Noon',
                  fontSize: 13.sp,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),

          Gap(12.h),

          if (widget.item.hadithText.trim().isNotEmpty)
            Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showHadith = !_showHadith;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showHadith
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.teal.shade700,
                        size: 20.sp,
                      ),
                      Gap(6.w),
                      Text(
                        _showHadith ? 'إخفاء الدليل' : 'عرض الدليل من السنة',
                        style: TextStyle(
                          fontFamily: 'Noon',
                          fontSize: 14.sp,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : const Color(0xffF3F7F5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.teal.shade700.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.item.hadithText,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Noon',
                    fontSize: widget.fontSize.sp,
                    height: 1.7.h,
                    color: isDark ? const Color(0xFFE0E0E0) : const Color(0xff2F2F2F),
                  ),
                ),
              ),
            ),
            crossFadeState: _showHadith
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _CustomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _CustomActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        splashColor: Colors.teal.shade200.withOpacity(0.4),
        highlightColor: Colors.teal.shade200.withOpacity(0.2),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.teal.shade700.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: Colors.teal.shade700,
              ),
              Gap(6.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Noon',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF3E4D5C),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}