import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class BuildCard extends StatelessWidget {
  const BuildCard({
    super.key,
    required this.context,
    required this.title,
    required this.children,
    required this.cardColor,
    required this.titleColor,
    required Color backgroundColor,
  });

  final BuildContext context;
  final String title;
  final List<Widget> children;
  final Color cardColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
          const Gap(14),
          ...children,
        ],
      ),
    );
  }
}
