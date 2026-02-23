import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DuaCard extends StatefulWidget {
  final String content;

  // Optional
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1c2227) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title (Optional)
          if (widget.title != null && widget.title!.isNotEmpty) ...[
            Text(
              widget.title!,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
            Gap(12.h),
          ],

          // 🔹 Content (Main)
          Text(
            widget.content,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Uthmani',
              fontSize: widget.fontSize.sp,
              height: 1.8,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          // 🔹 Reference (Optional)
          if (widget.reference != null && widget.reference!.isNotEmpty) ...[
            Gap(20.h),
            Text(
              "[ ${widget.reference} ]",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],

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
        borderRadius: BorderRadius.circular(12.r),
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
