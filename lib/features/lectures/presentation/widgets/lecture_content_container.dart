import 'package:flutter/material.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';

class LectureContentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const LectureContentContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final width = AppResponsive.width(context);

    final horizontalPadding = AppResponsive.isMobile(context)
        ? AppResponsive.widthValue(context, 16)
        : AppResponsive.isTablet(context)
        ? AppResponsive.widthValue(context, 24)
        : AppResponsive.widthValue(context, 32);

    final maxWidth = AppResponsive.isMobile(context)
        ? double.infinity
        : AppResponsive.isTablet(context)
        ? 960.0
        : 1200.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width < maxWidth ? width : maxWidth,
        ),
        child: Padding(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}
