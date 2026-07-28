import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StreamingIndicator extends StatefulWidget {
  final String sourceLabel;

  const StreamingIndicator({super.key, required this.sourceLabel});

  @override
  State<StreamingIndicator> createState() => _StreamingIndicatorState();
}

class _StreamingIndicatorState extends State<StreamingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _pulse,
          child: Container(
            width: 7.w,
            height: 7.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2ED9B8),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          widget.sourceLabel,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}