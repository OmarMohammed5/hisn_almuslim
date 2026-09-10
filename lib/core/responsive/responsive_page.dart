import 'package:flutter/material.dart';

import 'app_responsive.dart';

class ResponsivePage extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsivePage({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppResponsive.constrain(
      context,
      maxWidth: maxWidth,
      child: child,
    );
  }
}