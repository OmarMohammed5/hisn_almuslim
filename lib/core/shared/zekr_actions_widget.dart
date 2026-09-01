import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/helpers/share_helper.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import 'custom_snack_bar.dart';

class ZekrActionsWidget extends StatefulWidget {
  final String zekrText;

  const ZekrActionsWidget({super.key, required this.zekrText});

  @override
  State<ZekrActionsWidget> createState() => _ZekrActionsWidgetState();
}

class _ZekrActionsWidgetState extends State<ZekrActionsWidget>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;

  final ValueNotifier<bool> _copyNotifire = ValueNotifier(false);

  late final AnimationController _controller;

  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });

    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _close() {
    if (!_isOpen) return;

    setState(() {
      _isOpen = false;
    });

    _controller.reverse();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.zekrText));

    if (!mounted) return;

    _copyNotifire.value = true;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(customSnackBar('تم النسخ', Icons.check_circle, context));

    _close();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _copyNotifire.value = false;
      }
    });
  }

  Future<void> _share() async {
    await ShareHelper.shareAsImage(
      context,
      widget.zekrText,
      category: "أَذْكَارُ الصَّبَاح",
      isDark: Theme.of(context).brightness == Brightness.dark,
    );

    if (mounted) {
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = isDark
        ? Colors.tealAccent.shade700
        : Colors.teal.shade700;

    final buttonColor = isDark ? const Color(0xFF18332F) : Colors.white;

    final textColor = isDark ? Colors.white : const Color(0xFF252A28);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 145.w,
          height: 155.h,
          child: Stack(
            alignment: Alignment.bottomLeft,
            clipBehavior: Clip.none,
            children: [
              // SHARE
              _buildAction(
                icon: Icons.share_outlined,
                label: 'مشاركة',
                bottom: 110.h,
                animationOffset: -18.h,
                onTap: _share,
                accentColor: accentColor,
                buttonColor: buttonColor,
                textColor: textColor,
              ),

              // COPY
              _buildAction(
                icon: Icons.copy_rounded,
                label: 'نسخ',
                bottom: 65.h,
                animationOffset: -10.h,
                onTap: _copy,
                accentColor: accentColor,
                buttonColor: buttonColor,
                textColor: textColor,
              ),

              // MAIN FAB
              Positioned(
                left: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _toggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    width: 58.w,
                    height: 58.w,
                    transform: Matrix4.identity()
                      ..rotateZ(_animation.value * 0.785),
                    transformAlignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(
                      _isOpen ? Icons.close_rounded : Icons.more_horiz_rounded,
                      color: Colors.white,
                      size: 25.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAction({
    required IconData icon,
    required String label,
    required double bottom,
    required double animationOffset,
    required VoidCallback onTap,
    required Color accentColor,
    required Color buttonColor,
    required Color textColor,
  }) {
    final value = _animation.value;

    return Positioned(
      left: 0,
      bottom: bottom - (animationOffset * (1 - value)),
      child: IgnorePointer(
        ignoring: value < .8,
        child: Opacity(
          opacity: value,
          child: Transform.scale(
            scale: .85 + (.15 * value),
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 7.w, right: 7.w),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: accentColor.withValues(alpha: .10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: .10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accentColor, size: 16.sp),
                    ),

                    SizedBox(width: 7.w),

                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Noon',
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),

                    SizedBox(width: 8.w),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
