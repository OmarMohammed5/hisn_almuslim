import 'package:flutter/material.dart';

class HadithNumber extends StatefulWidget {
  const HadithNumber({super.key, required this.number});
  final int number;
  @override
  State<HadithNumber> createState() => _HadithNumberState();
}

class _HadithNumberState extends State<HadithNumber> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade700, Colors.teal.shade900],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF677C8D).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'الحديث رقم ${widget.number}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
      ),
    );
  }
}
