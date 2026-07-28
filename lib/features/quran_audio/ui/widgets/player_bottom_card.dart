import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerBottomCard extends StatelessWidget {
  final Widget slider;
  final Widget timeRow;
  final Widget controls;
  final Widget speedControl;
  // final Widget bottomInfo;

  const PlayerBottomCard({
    super.key,
    required this.slider,
    required this.timeRow,
    required this.controls,
    required this.speedControl,
    // required this.bottomInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              slider,
              timeRow,
              SizedBox(height: 14.h),
              controls,
              SizedBox(height: 16.h),
              speedControl,
              SizedBox(height: 14.h),
              // bottomInfo,
            ],
          ),
        ),
      ),
    );
  }
}