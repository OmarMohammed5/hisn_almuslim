import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hisn_almuslim/features/asma%20allah/data/cubit/asma_allah_cubit.dart';
import 'package:hisn_almuslim/features/asma%20allah/widgets/asma_card.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

class AsmaAllahScreen extends StatefulWidget {
  const AsmaAllahScreen({super.key});

  @override
  State<AsmaAllahScreen> createState() => _AsmaAllahScreenState();
}

class _AsmaAllahScreenState extends State<AsmaAllahScreen> {
  late final PageController _controller;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController(viewportFraction: .88);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AsmaAllahCubit>().loadNames();
      }
    });
  }

  void _goToNextPage(AsmaAllahLoaded state) {
    if (currentIndex >= state.names.length - 1) {
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AsmaAllahCubit, AsmaAllahState>(
      builder: (context, state) {
        if (state is AsmaAllahLoading) {
          return Scaffold(
            backgroundColor: _backgroundColor(isDark),
            body: Center(
              child: CupertinoActivityIndicator(
                color: _accentColor(isDark),
                radius: 14.r,
              ),
            ),
          );
        }

        if (state is AsmaAllahError) {
          return Scaffold(
            backgroundColor: _backgroundColor(isDark),
            body: Center(
              child: CustomText(
                state.message,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          );
        }

        if (state is! AsmaAllahLoaded) {
          return const SizedBox.shrink();
        }

        final names = state.names;

        return Scaffold(
          backgroundColor: _backgroundColor(isDark),

          body: SafeArea(
            child: Column(
              children: [
                // HEADER
                _buildHeader(
                  context: context,
                  isDark: isDark,
                  total: names.length,
                ),

                // PROGRESS
                _buildProgress(isDark: isDark, total: names.length),

                SizedBox(height: 18.h),

                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: names.length,

                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },

                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _controller,

                        builder: (context, child) {
                          double page = currentIndex.toDouble();

                          if (_controller.hasClients &&
                              _controller.page != null) {
                            page = _controller.page!;
                          }

                          final difference = (index - page).abs().clamp(
                            0.0,
                            1.0,
                          );

                          final scale = 1.0 - (difference * .035);

                          final opacity = 1.0 - (difference * .22);

                          final offsetY = difference * 10.h;

                          return Opacity(
                            opacity: opacity,

                            child: Transform.translate(
                              offset: Offset(0, offsetY),

                              child: Transform.scale(
                                scale: scale,

                                child: child,
                              ),
                            ),
                          );
                        },

                        child: AsmaCard(
                          key: ValueKey(index),
                          model: names[index],
                          onTap: () {
                            _goToNextPage(state);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // HEADER
  Widget _buildHeader({
    required BuildContext context,
    required bool isDark,
    required int total,
  }) {
    final accent = _accentColor(isDark);
    final textColor = _textColor(isDark);

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
      child: Row(
        children: [
          _buildIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Spacer(),

          // TITLE
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                'أسماء الله الحسنى',
                color: textColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),

              SizedBox(height: 3.h),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                  ),

                  SizedBox(width: 5.w),

                  CustomText(
                    'تعرّف على أسماء الله',
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // COUNTER
          Container(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: accent.withValues(alpha: .15)),
            ),
            child: Text(
              '${_arabicNumber(currentIndex + 1)} / ${_arabicNumber(total)}',
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PROGRESS
  Widget _buildProgress({required bool isDark, required int total}) {
    final accent = _accentColor(isDark);

    final progress = total == 0 ? 0.0 : (currentIndex + 1) / total;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SizedBox(
              height: 3.h,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: accent.withValues(alpha: .08),
                  ),

                  FractionallySizedBox(
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ICON BUTTON
  Widget _buildIconButton({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final accent = _accentColor(isDark);

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(14.r),

        child: Container(
          width: 42.w,
          height: 42.w,

          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: .045) : Colors.white,
            borderRadius: BorderRadius.circular(14.r),

            border: Border.all(color: accent.withValues(alpha: .10)),
          ),

          child: Icon(
            icon,
            size: 16.sp,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }


  // COLORS
  Color _backgroundColor(bool isDark) {
    return isDark ? const Color(0xFF0E1715) : const Color(0xFFF7F9F7);
  }

  Color _accentColor(bool isDark) {
    return isDark ? const Color(0xFF63D8C2) : const Color(0xFF087F73);
  }

  Color _textColor(bool isDark) {
    return isDark ? const Color(0xFFE9F0ED) : const Color(0xFF1E2925);
  }

  // ARABIC NUMBERS
  String _arabicNumber(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    return number
        .toString()
        .split('')
        .map((digit) => digits[int.parse(digit)])
        .join();
  }
}
