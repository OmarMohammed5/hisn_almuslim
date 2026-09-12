import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/features/asma%20allah/data/cubit/asma_allah_cubit.dart';
import 'package:hisn_almuslim/features/asma%20allah/widgets/asma_card.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';

import '../../../core/theme/app_colors.dart';

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

                SizedBox(height: AppResponsive.heightValue(context, 18)),

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

                          final offsetY = difference * AppResponsive.heightValue(context, 10);

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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppResponsive.widthValue(context, 12),
        AppResponsive.heightValue(context, 8),
        AppResponsive.widthValue(context, 12),
        AppResponsive.heightValue(context, 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            isDark: isDark,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // TITLE
          CustomText(
            'أسماء الله الحسنى',
            color: textColor,
            fontSize: AppResponsive.fontSize(context, 14),
            fontWeight: FontWeight.w800,
          ),
          // COUNTER
          Container(
            width: AppResponsive.widthValue(context, 65),
            height: AppResponsive.heightValue(context, 30),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: borderColor,
                width: AppResponsive.widthValue(context, 1),
              ),
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, 13),
              ),
            ),
            child: Center(
              child: Text(
                '${_arabicNumber(currentIndex + 1)} / ${_arabicNumber(total)}',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 11),
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 22),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context, 20)),
            child: SizedBox(
              height: AppResponsive.heightValue(context, 3),
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
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 20),
                        ),
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

        borderRadius: BorderRadius.circular(AppResponsive.radius(context, 14)),

        child: Container(
          width: AppResponsive.widthValue(context, 37),
          height: AppResponsive.heightValue(context, 37),

          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: .045) : Colors.white,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 14),
            ),

            border: Border.all(color: accent.withValues(alpha: .10)),
          ),

          child: Icon(
            icon,
            size: AppResponsive.iconSize(context, 16),
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
