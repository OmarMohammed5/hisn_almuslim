import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class NowPlayingHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String reciterName;
  final String? rewaya;

  const NowPlayingHeader({
    super.key,
    required this.onBack,
    required this.reciterName,
    this.rewaya,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Column(
        children: [
          Row(
            children: [
              _circleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onBack,
              ),
              Expanded(
                child: CustomText(
                  'يُتلى الآن',
                  textAlign: TextAlign.center,
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                ),
              ),
              // Balances the back button so the title stays centered.
              SizedBox(width: 44.w),
            ],
          ),
          const Gap(6),
          CustomText(
            rewaya != null && rewaya!.isNotEmpty
                ? '$reciterName • $rewaya'
                : reciterName,
            textAlign: TextAlign.center,
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }
}