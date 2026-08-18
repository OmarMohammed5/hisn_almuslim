// lib/core/utils/arabic_digits.dart

String toArabicDigits(int number) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  var text = number.toString();
  for (var i = 0; i < western.length; i++) {
    text = text.replaceAll(western[i], eastern[i]);
  }
  return text;
}