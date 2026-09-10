import 'package:flutter/material.dart';
import '../../../core/responsive/app_responsive.dart';
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
        margin: EdgeInsets.only(bottom: AppResponsive.heightValue(context, 12)),
        padding: EdgeInsets.all(AppResponsive.widthValue(context, 12)),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.green[900]! : Colors.green[50])
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
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
                  padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 8), vertical: AppResponsive.heightValue(context, 4)),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.green[800] : Colors.green[100],
                    borderRadius: BorderRadius.circular(AppResponsive.radius(context, 16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '﴿${ayah.number}﴾',
                        style: TextStyle(
                          fontFamily: 'Uthmanic',
                          fontSize: AppResponsive.fontSize(context, 14),
                          color: isDark ? Colors.white : Colors.green[800],
                        ),
                      ),
                      if (ayah.isSajdah) ...[
                        SizedBox(width: AppResponsive.widthValue(context, 4)),
                        Icon(
                          Icons.star,
                          size: AppResponsive.fontSize(context, 14),
                          color: Colors.amber,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.heightValue(context, 8)),

            // Ayah Text
            Text(
              ayah.text,
              style: TextStyle(
                fontFamily: 'Uthmanic',
                fontSize: AppResponsive.fontSize(context, 20),
                height: 1.8,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),

            // Page and Juz info (optional)
            if (ayah.number == 1) ...[
              SizedBox(height: AppResponsive.heightValue(context, 8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfoChip(context, 'صفحة ${ayah.page}', Icons.description),
                  SizedBox(width: AppResponsive.widthValue(context, 8)),
                  _buildInfoChip(context, 'جزء ${ayah.juz}', Icons.book),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 8), vertical: AppResponsive.heightValue(context, 3)),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppResponsive.fontSize(context, 12), color: Colors.grey[600]),
          SizedBox(width: AppResponsive.widthValue(context, 4)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 10),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}