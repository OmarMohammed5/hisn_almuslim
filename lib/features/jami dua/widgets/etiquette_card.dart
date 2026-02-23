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
        color: isDark ? Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟢 نص الأدب
          Text(
            widget.item.arabic,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Uthmani',
              fontSize: widget.fontSize.sp,
              height: 1.8.h,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          Gap(12.h),

          Row(
            children: [
              Icon(Icons.bookmark_border, size: 16.sp, color: Colors.grey),
              Gap(4.w),
              Text(
                widget.item.reference,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          Gap(12.h),

          if (widget.item.hadithText.trim().isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showHadith = !_showHadith;
                });
              },
              child: Row(
                children: [
                  Icon(
                    _showHadith
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.teal.shade700,
                  ),
                  Gap(4.w),
                  Text(
                    _showHadith ? 'إخفاء الدليل' : 'عرض الدليل من السنة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Text of Hadith
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black38 : Color(0xffF3F7F5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.item.hadithText,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Uthmani',
                    fontSize: widget.fontSize.sp,
                    height: 1.7.h,
                    color: isDark ? Colors.white : Color(0xff2F2F2F),
                  ),
                ),
              ),
            ),
            crossFadeState: _showHadith
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),

          Gap(16.h),
          Divider(height: 1.h, color: isDark ? Colors.white12 : Colors.black54),
          Gap(16.h),

          // 🔘 Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionIcon(icon: Icons.copy, label: 'نسخ', onTap: widget.onCopy),
              Gap(16.w),
              _ActionIcon(
                icon: Icons.share,
                label: 'مشاركة',
                onTap: widget.onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade600,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Row(
            children: [
              Icon(icon, size: 15.sp, color: Colors.white),
              Gap(4.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
