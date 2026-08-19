import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/prophet_story.dart';

class StoryActions extends StatelessWidget {
  final ProphetStory story;
  final double fontSize;
  final VoidCallback onIncreaseFontSize;
  final VoidCallback onDecreaseFontSize;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const StoryActions({
    Key? key,
    required this.story,
    required this.fontSize,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
    required this.onShare,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Font size controls
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 20.sp),
                onPressed: onDecreaseFontSize,
                constraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 40.h,
                ),
                padding: EdgeInsets.zero,
              ),
              SizedBox(width: 4.w),
              Text(
                'Aa',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 4.w),
              IconButton(
                icon: Icon(Icons.add, size: 20.sp),
                onPressed: onIncreaseFontSize,
                constraints: BoxConstraints(
                  minWidth: 40.w,
                  minHeight: 40.h,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          Container(
            width: 1.w,
            height: 30.h,
            color: Theme.of(context).dividerColor,
          ),
          // Action buttons
          IconButton(
            icon: Icon(Icons.share, size: 22.sp),
            onPressed: onShare,
          ),
          IconButton(
            icon: Icon(Icons.copy, size: 22.sp),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}