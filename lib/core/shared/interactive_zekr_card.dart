import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InteractiveZekrCard extends StatefulWidget {
  final String text;
  final int count;
  final String? fadl;
  final VoidCallback onCompleted;
  final double size;

  const InteractiveZekrCard({
    super.key,
    required this.text,
    required this.count,
    this.fadl,
    required this.onCompleted, required this.size,
  });

  @override
  State<InteractiveZekrCard> createState() => _InteractiveZekrCardState();
}

class _InteractiveZekrCardState extends State<InteractiveZekrCard> {
  late final ValueNotifier<int> _repetition;
  bool _isCompleting = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _repetition = ValueNotifier(0);
  }


  @override
  void didUpdateWidget(covariant InteractiveZekrCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _repetition.value = 0;
      _isCompleting = false;
    }
  }

  String _toArabicNumber(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((d) => arabicDigits[int.parse(d)])
        .join();
  }

  @override
  void dispose() {
    _repetition.dispose();
    super.dispose();
  }

  // void _handleTap() {
  //   if (_isCompleting || _repetition.value >= widget.count) return;
  //
  //   setState(() => _isPressed = true);
  //   Future.delayed(const Duration(milliseconds: 120), () {
  //     if (mounted) setState(() => _isPressed = false);
  //   });
  //
  //   _repetition.value += 1;
  //
  //   if (_repetition.value >= widget.count) {
  //     setState(() => _isCompleting = true);
  //     // brief pause so the user sees the completed ring + check mark
  //     Future.delayed(const Duration(milliseconds: 420), () {
  //       if (mounted) widget.onCompleted();
  //     });
  //   }
  // }

  void _handleTap() {
    if (_isCompleting || _repetition.value >= widget.count) return;

    setState(() => _isPressed = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _isPressed = false);
    });

    _repetition.value += 1;

    if (_repetition.value >= widget.count) {
      HapticFeedback.lightImpact();
      // print('🔔 Haptic triggered');

      setState(() => _isCompleting = true);
      Future.delayed(const Duration(milliseconds: 420), () {
        if (mounted) widget.onCompleted();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final accentColor =
    isDark ? Colors.tealAccent.shade200 : Colors.teal.shade700;
    final trackColor = accentColor.withOpacity(0.12);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProgressRing(accentColor, trackColor),
              const SizedBox(height: 28),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontFamily: "Noon",
                  fontSize: widget.size,
                  fontWeight: FontWeight.w700,
                  height: 2,
                ),
              ),
              if (widget.fadl != null && widget.fadl!.isNotEmpty)
                _buildFadlSection(isDark, accentColor),
              _buildCompletionCheck(accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressRing(Color accentColor, Color trackColor) {
    return ValueListenableBuilder<int>(
      valueListenable: _repetition,
      builder: (context, rep, _) {
        final progress = widget.count == 0 ? 0.0 : rep / widget.count;
        return SizedBox(
          width: 65.w,
          height: 55.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                builder: (context, value, _) => SizedBox(
                  width: 65.w,
                  height: 55.h,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 6,
                    backgroundColor: trackColor,
                    valueColor: AlwaysStoppedAnimation(accentColor),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Text(
                  // '${widget.count}/$rep',
                 ' ${_toArabicNumber(widget.count)} / ${_toArabicNumber(rep)}',
                  key: ValueKey(rep),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFadlSection(bool isDark, Color accentColor) {
    return Column(
      children: [
         SizedBox(height: 24.h),
        Divider(
          thickness: 0.8,
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
         SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding:  EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(isDark ? 0.08 : 0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            "الفضل: ${widget.fadl}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.size,
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: accentColor,
              fontFamily: "Noon",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionCheck(Color accentColor) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isCompleting
          ? Padding(
        key: const ValueKey('done'),
        padding:  EdgeInsets.only(top: 20.h),
        child: AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.elasticOut,
          child: Icon(Icons.check_circle_rounded,
              color: accentColor, size: 34.sp),
        ),
      )
          : const SizedBox(height: 0, key: ValueKey('empty')),
    );
  }
}