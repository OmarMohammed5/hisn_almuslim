import 'package:flutter/material.dart';

class ZekrShareCard extends StatelessWidget {
  final String text;
  final String logoPath;

  const ZekrShareCard({super.key, required this.text, required this.logoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Image.asset(logoPath, width: 80, height: 80),
          const SizedBox(height: 20),

          // Content
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Amiri Quran",
              fontSize: 20,
              height: 1.6,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
