import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class InteractiveZekrCard extends StatefulWidget {
  final String text;
  final int count;
  final String? fadl;
  final VoidCallback onCompleted;
  final double size;
  final int currentIndex;
  final int total;

  const InteractiveZekrCard({
    super.key,
    required this.text,
    required this.count,
    this.fadl,
    required this.onCompleted,
    required this.size,
    required this.currentIndex,
    required this.total,
  });

  @override
  State<InteractiveZekrCard> createState() => _InteractiveZekrCardState();
}

class _InteractiveZekrCardState extends State<InteractiveZekrCard> {
  int _repetition = 0;
  bool _isPressed = false;
  bool _isCompleted = false;

  void _handleTap() {
    if (_isCompleted || widget.count <= 0) return;

    HapticFeedback.selectionClick();

    setState(() {
      _isPressed = true;
      _repetition++;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      setState(() {
        _isPressed = false;
      });
    });

    if (_repetition >= widget.count) {
      _complete();
    }
  }

  void _complete() {
    HapticFeedback.lightImpact();

    setState(() {
      _isCompleted = true;
    });

    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      widget.onCompleted();
    });
  }

  @override
  void didUpdateWidget(covariant InteractiveZekrCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text || oldWidget.count != widget.count) {
      setState(() {
        _repetition = 0;
        _isPressed = false;
        _isCompleted = false;
      });
    }
  }

  String _arabicNumber(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    return number.toString().split('').map((e) => digits[int.parse(e)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark
        ? const Color(0xFF1B211F)
        : const Color(0xFFFFFFFF);

    final textColor = isDark
        ? const Color(0xFFEAE8E0)
        : const Color(0xFF242926);

    final mutedColor = isDark
        ? const Color(0xFF89938E)
        : const Color(0xFF929995);

    final accentColor = isDark
        ? const Color(0xFF70D3BF)
        : const Color(0xFF087F73);


    final progress = widget.count <= 0
        ? 0.0
        : (_repetition / widget.count).clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? .985 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: accentColor.withValues(alpha: _isCompleted ? .25 : .055),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .16 : .055),
                blurRadius: 18.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: Column(
            children: [
              // HEADER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + PAGE COUNTER
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),

                                SizedBox(width: 7.w),

                                Text(
                                  'الذكر',
                                  style: TextStyle(
                                    fontFamily: 'Noon',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: mutedColor,
                                  ),
                                ),
                              ],
                            ),

                            // PAGE COUNTER
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: .20),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    '${widget.currentIndex + 1}',
                                    color: accentColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),

                                  CustomText(
                                    ' / ',
                                    color: textColor.withValues(alpha: .4),
                                    fontSize: 12.sp,
                                  ),

                                  CustomText(
                                    '${widget.total}',
                                    color: textColor.withValues(alpha: .6),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        Text(
                          _isCompleted
                              ? 'تم إكمال الذكر'
                              : 'اضغط على الذكر للتكرار',
                          style: TextStyle(
                            fontFamily: 'Noon',
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // CIRCULAR PROGRESS
                  _buildCircularProgress(
                    progress: progress,
                    accentColor: accentColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  ),
                ],
              ),

              SizedBox(height: 22.h),

              // ZEKR TEXT
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .025)
                      : const Color(0xFFFAFAF7),
                  borderRadius: BorderRadius.circular(17.r),
                ),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Noon',
                    fontSize: widget.size,
                    fontWeight: FontWeight.w700,
                    height: 2,
                    color: textColor,
                  ),
                ),
              ),

              // FADL
              if (widget.fadl != null && widget.fadl!.trim().isNotEmpty)
                _buildFadl(
                  isDark: isDark,
                  accentColor: accentColor,
                  mutedColor: mutedColor,
                ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  // CIRCULAR PROGRESS
  Widget _buildCircularProgress({
    required double progress,
    required Color accentColor,
    required Color mutedColor,
    required bool isDark,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        return SizedBox(
          width: 68.w,
          height: 68.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // BACKGROUND RING
              SizedBox(
                width: 62.w,
                height: 62.w,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 5.w,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    mutedColor.withValues(alpha: .10),
                  ),
                ),
              ),

              // ACTIVE RING
              SizedBox(
                width: 62.w,
                height: 62.w,
                child: CircularProgressIndicator(
                  value: animatedProgress,
                  strokeWidth: 5.w,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(accentColor),
                ),
              ),

              // COUNTER
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: _isCompleted
                    ? Icon(
                        Icons.check_rounded,
                        key: const ValueKey('done'),
                        color: accentColor,
                        size: 24.sp,
                      )
                    : Column(
                        key: ValueKey(_repetition),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_arabicNumber(_repetition)} / ${_arabicNumber(widget.count)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // FADL
  Widget _buildFadl({
    required bool isDark,
    required Color accentColor,
    required Color mutedColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 17.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: isDark ? .055 : .035),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: accentColor.withValues(alpha: .06)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14.sp,
                  color: accentColor,
                ),

                SizedBox(width: 5.w),

                CustomText(
                  'فضل الذكر',
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ],
            ),

            SizedBox(height: 7.h),

            CustomText(
              widget.fadl!,
              maxLines: 20,
              textAlign: TextAlign.center,
              fontFamily: 'Noon',
              fontSize: widget.size * .70,
              height: 1.7,
              fontWeight: FontWeight.w600,
              color: mutedColor,
            ),
          ],
        ),
      ),
    );
  }
}
