import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../domain/entities/jami_dua_category.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/app_responsive.dart';

class EtiquetteCard extends StatefulWidget {
  final JamiDuaItem item;
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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;


    return Container(
      margin: EdgeInsets.only(bottom: AppResponsive.heightValue(context, 16)),
      padding: EdgeInsets.all(AppResponsive.widthValue(context, 20)),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 18)),
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
              Gap(AppResponsive.widthValue(context, 12)),
              _CustomActionButton(
                icon: Icons.share_outlined,
                label: 'مشاركة',
                onTap: widget.onShare,
                isDark: isDark,
              ),
            ],
          ),

          Gap(AppResponsive.heightValue(context, 12)),

          Divider(
            height: AppResponsive.heightValue(context, 1),
            color: isDark ? Colors.white12 : Colors.black12,
            thickness: 1,
          ),

          Gap(AppResponsive.heightValue(context, 16)),

          Text(
            widget.item.content,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Noon',
              fontSize: AppResponsive.fontSize(context, widget.fontSize),
              height: 1.8,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A),
            ),
          ),

          Gap(AppResponsive.heightValue(context, 12)),

          if (widget.item.reference?.trim().isNotEmpty ?? false)
            Row(
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: AppResponsive.iconSize(context, 16),
                  color: Colors.grey.shade600,
                ),
                Gap(AppResponsive.widthValue(context, 6)),
                Expanded(
                  child: Text(
                    widget.item.reference!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Noon',
                      fontSize: AppResponsive.fontSize(context, 13),
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),

          Gap(AppResponsive.heightValue(context, 12)),

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
                  padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 4), vertical: AppResponsive.heightValue(context, 4)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showHadith
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.teal.shade700,
                        size: AppResponsive.iconSize(context, 20),
                      ),
                      Gap(AppResponsive.widthValue(context, 6)),
                      Text(
                        _showHadith ? 'إخفاء الدليل' : 'عرض الدليل من السنة',
                        style: TextStyle(
                          fontFamily: 'Noon',
                          fontSize: AppResponsive.fontSize(context, 14),
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
              padding: EdgeInsets.only(top: AppResponsive.heightValue(context, 12)),
              child: Container(
                padding: EdgeInsets.all(AppResponsive.widthValue(context, 14)),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : const Color(0xffF3F7F5),
                  borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
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
                    fontSize: AppResponsive.fontSize(context, widget.fontSize),
                    height: 1.7,
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
        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
        onTap: onTap,
        splashColor: Colors.teal.shade200.withOpacity(0.4),
        highlightColor: Colors.teal.shade200.withOpacity(0.2),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppResponsive.widthValue(context, 12), vertical: AppResponsive.heightValue(context, 8)),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 12)),
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
                size: AppResponsive.iconSize(context, 16),
                color: Colors.teal.shade700,
              ),
              Gap(AppResponsive.widthValue(context, 6)),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Noon',
                  fontSize: AppResponsive.fontSize(context, 13),
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