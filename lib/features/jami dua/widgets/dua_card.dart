import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DuaCard extends StatefulWidget {
  final String content;
  final String? title;
  final String? reference;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final double fontSize;

  const DuaCard({
    super.key,
    required this.content,
    this.title,
    this.reference,
    required this.onCopy,
    required this.onShare,
    required this.fontSize,
  });

  @override
  State<DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<DuaCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

          Gap(10.h),
          Divider(
            height: 1.h,
            color: isDark ? Colors.white12 : Colors.black12,
            thickness: 1,
          ),
          Gap(16.h),

          if (widget.title != null && widget.title!.isNotEmpty) ...[
            Text(
              widget.title!,
              style: TextStyle(
                fontFamily: 'Noon',
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            Gap(16.h),
          ],

          Text(
            widget.content,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Noon',
              fontSize: widget.fontSize.sp,
              height: 1.8,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A), // ألوان أكثر نعومة
            ),
          ),

          // 🔹 Reference (Optional)
          if (widget.reference != null && widget.reference!.isNotEmpty) ...[
            Gap(16.h),
            Text(
              "[ ${widget.reference} ]",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Noon',
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
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
                  fontFamily: 'QuranFont',
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