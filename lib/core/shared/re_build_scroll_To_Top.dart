import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

class ReBuildScrollToTop extends StatelessWidget {
  const ReBuildScrollToTop({
    super.key,
    required ValueNotifier<bool> showScrollToTop,
    required ScrollController scrollController,
  }) : _showScrollToTop = showScrollToTop,
       _scrollController = scrollController;

  final ValueNotifier<bool> _showScrollToTop;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showScrollToTop,
      builder: (context, show, child) {
        return AnimatedScale(
          scale: show ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              backgroundColor: AppColors.kPrimary,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
              child: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
