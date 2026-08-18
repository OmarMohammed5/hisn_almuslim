import 'package:flutter/material.dart';


PageRoute<T> slidePageRoute<T>({
  required Widget child,
  required RouteSettings settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,

    // Animation duration when opening the new page.
    transitionDuration: const Duration(
      milliseconds: 230,
    ),

    // Animation duration when going back.
    reverseTransitionDuration: const Duration(
      milliseconds: 190,
    ),

    // The actual page that will be displayed.
    pageBuilder: (context, animation, secondaryAnimation) {
      return child;
    },

    // Defines how the page enters and exits the screen.
    transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
        ) {

      final slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,


          curve: Curves.easeOutCubic,
        ),
      );

      // Apply the horizontal slide to the page.
      return SlideTransition(
        position: slideAnimation,
        child: child,
      );
    },
  );
}