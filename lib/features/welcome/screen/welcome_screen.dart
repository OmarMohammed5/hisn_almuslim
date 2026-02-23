import 'package:flutter/material.dart';
import 'package:hisn_almuslim/features/welcome/widgets/introduction.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1c2227), Colors.teal.shade900, Color(0xff1c2227)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:
          // Inroduction Screen
          Introduction(),
    );
  }
}
