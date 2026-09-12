import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import '../theme/app_colors.dart';
import '../responsive/app_responsive.dart';

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

    final bgColor = isDark ? AppColors.kSurfaceDark : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.kBorderLight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _isPressed ? .985 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: AppResponsive.widthValue(context, 12),
            vertical: 8,
          ),
          padding: EdgeInsets.all(AppResponsive.widthValue(context, 18)),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .16 : .055),
                blurRadius: 2,
                offset: const Offset(0, 2),
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
                          spacing: AppResponsive.widthValue(context, 8),
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [

                            //  COUNTER
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.widthValue(
                                  context,
                                  10,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(
                                  AppResponsive.radius(context, 12),
                                ),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: .20),
                                  width: AppResponsive.widthValue(context, 1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    '${widget.currentIndex + 1}',
                                    color: accentColor,
                                    fontSize: AppResponsive.fontSize(
                                      context,
                                      14,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Cairo",
                                  ),

                                  CustomText(
                                    ' / ',
                                    color: textColor.withValues(alpha: .4),
                                    fontSize: AppResponsive.fontSize(
                                      context,
                                      10.3,
                                    ),
                                    fontFamily: "Cairo",
                                  ),

                                  CustomText(
                                    '${widget.total}',
                                    color: textColor.withValues(alpha: .6),
                                    fontSize: AppResponsive.fontSize(
                                      context,
                                      10.3,
                                    ),
                                    fontFamily: "Cairo",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: AppResponsive.heightValue(context, 10),
                        ),

                        Text(
                          _isCompleted
                              ? 'تم إكمال الذكر'
                              : 'اضغط على الذكر للتكرار',
                          style: TextStyle(
                            fontFamily: 'Noon',
                            fontSize: AppResponsive.fontSize(context, 9),
                            fontWeight: FontWeight.w600,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: AppResponsive.widthValue(context, 10)),

                  // CIRCULAR PROGRESS
                  _buildCircularProgress(
                    progress: progress,
                    accentColor: accentColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  ),
                ],
              ),

              SizedBox(height: AppResponsive.heightValue(context, 18)),

              // ZEKR TEXT
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 12),
                  vertical: AppResponsive.heightValue(context, 16),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: .025)
                      : AppColors.kPrimary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 17),
                  ),
                ),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Noon',
                    fontSize: AppResponsive.fontSize(context, widget.size),
                    fontWeight: FontWeight.w700,
                    height: AppResponsive.heightValue(context, 2),
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

              SizedBox(height: AppResponsive.heightValue(context, 18)),
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
          width: AppResponsive.widthValue(context, 68),
          height: AppResponsive.widthValue(context, 68),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // BACKGROUND RING
              SizedBox(
                width: AppResponsive.widthValue(context, 62),
                height: AppResponsive.widthValue(context, 62),
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: AppResponsive.widthValue(context, 5),
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    mutedColor.withValues(alpha: .10),
                  ),
                ),
              ),

              // ACTIVE RING
              SizedBox(
                width: AppResponsive.widthValue(context, 62),
                height: AppResponsive.widthValue(context, 62),
                child: CircularProgressIndicator(
                  value: animatedProgress,
                  strokeWidth: AppResponsive.widthValue(context, 5),
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
                        size: AppResponsive.iconSize(context, 24),
                      )
                    : Column(
                        key: ValueKey(_repetition),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_arabicNumber(_repetition)} / ${_arabicNumber(widget.count)}',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 16),
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
      padding: EdgeInsets.only(top: AppResponsive.heightValue(context, 18)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 14),
          vertical: AppResponsive.heightValue(context, 14),
        ),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: isDark ? .055 : .035),
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 14),
          ),
          border: Border.all(color: accentColor.withValues(alpha: .06)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: AppResponsive.iconSize(context, 20),
                  color: accentColor,
                ),

                SizedBox(width: AppResponsive.widthValue(context, 5)),

                CustomText(
                  'فضل الذكر',
                  fontSize: AppResponsive.fontSize(context, 10.4),
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ],
            ),

            SizedBox(height: AppResponsive.heightValue(context, 7)),

            CustomText(
              widget.fadl!,
              maxLines: 30,
              textAlign: TextAlign.center,
              fontFamily: 'Noon',
              fontSize: AppResponsive.fontSize(context, widget.size) * .55 ,
              height: AppResponsive.heightValue(context, 1.5),
              fontWeight: FontWeight.w600,
              color: mutedColor,
            ),
          ],
        ),
      ),
    );
  }
}
