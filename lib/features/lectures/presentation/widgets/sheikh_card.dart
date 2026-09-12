import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../../domain/entities/sheikh.dart';

class SheikhCard extends StatelessWidget {
  final Sheikh sheikh;
  final VoidCallback onTap;
  final bool selected;

  const SheikhCard({
    super.key,
    required this.sheikh,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;


    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
                blurRadius: AppResponsive.radius(context, 8),
                offset: Offset(0, AppResponsive.heightValue(context, 3)),
              ),
            ],
          ),
          // Padding creates the "frame" effect around the image
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),
            child: AspectRatio(
              aspectRatio: 1.0, // Forces a perfect square
              child: CachedNetworkImage(
                imageUrl: sheikh.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.kPrimary,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.kPrimary.withValues(alpha: 0.08),
                  child: Icon(
                    Icons.person_rounded,
                    size: AppResponsive.fontSize(context, 32),
                    color: AppColors.kPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}