import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../domain/entities/ayah_entity.dart';

class AyahCard extends StatelessWidget {
  final AyahEntity ayah;
  final bool isSelected;
  final VoidCallback onTap;

  const AyahCard({
    super.key,
    required this.ayah,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.green[900]! : Colors.green[50])
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: Colors.green, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Ayah Number Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.green[800] : Colors.green[100],
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '﴿${ayah.number}﴾',
                        style: TextStyle(
                          fontFamily: 'Uthmanic',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.green[800],
                        ),
                      ),
                      if (ayah.isSajdah) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.star,
                          size: 14.sp,
                          color: Colors.amber,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Ayah Text
            Text(
              ayah.text,
              style: TextStyle(
                fontFamily: 'Uthmanic',
                fontSize: 20.sp,
                height: 1.8,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),

            // Page and Juz info (optional)
            if (ayah.number == 1) ...[
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoChip('صفحة ${ayah.page}', Icons.description),
                  SizedBox(width: 8.w),
                  _buildInfoChip('جزء ${ayah.juz}', Icons.book),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: Colors.grey[600]),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}