import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final double maxLines;
  final TextAlign? textAlign;
  final double? height;
  final String? fontFamily;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize = 19,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.maxLines = 1,
    this.textAlign,
    this.height = 1,
    this.fontFamily = "QuranFont",
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textDirection: TextDirection.rtl,
      text,
      maxLines: maxLines.toInt(),
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        height: height,
        fontSize: fontSize.sp ?? 19.sp,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? "QuranFont",
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}
