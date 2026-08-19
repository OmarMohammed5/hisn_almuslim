import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'nav_button.dart';

class StoryNavigation extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final int currentIndex;
  final int totalStories;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const StoryNavigation({
    required this.isFirst,
    required this.isLast,
    required this.currentIndex,
    required this.totalStories,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Row(
        children: [
          // Previous
          NavButton(
            label: 'السابق',
            onTap: isFirst ? null : onPrevious,
            enabled: !isFirst,
          ),
          const Spacer(),
          // Position indicator
          Text(
            '${currentIndex + 1} / $totalStories',
            style: TextStyle(
              fontSize: 11.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.25),
              fontFamily: 'Cairo',
            ),
          ),
          const Spacer(),
          // Next
          NavButton(
            label: 'التالي',
            onTap: isLast ? null : onNext,
            enabled: !isLast,
            isNext: true,
          ),
        ],
      ),
    );
  }
}


