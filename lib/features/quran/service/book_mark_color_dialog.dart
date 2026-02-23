import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';

class BookmarkColorDialog extends StatefulWidget {
  final String? currentColorHex;

  const BookmarkColorDialog({super.key, this.currentColorHex});

  @override
  State<BookmarkColorDialog> createState() => _BookmarkColorDialogState();
}

class _BookmarkColorDialogState extends State<BookmarkColorDialog> {
  final List<Map<String, dynamic>> _colors = [
    {'name': 'أحمر', 'hex': 'FFE53935', 'color': const Color(0xFFE53935)},
    {'name': 'أزرق', 'hex': 'FF1E88E5', 'color': const Color(0xFF1E88E5)},
    {'name': 'أخضر', 'hex': 'FF43A047', 'color': const Color(0xFF43A047)},
    {'name': 'ذهبي', 'hex': 'FFFFD600', 'color': const Color(0xFFFFD600)},
    {'name': 'بنفسجي', 'hex': 'FF8E24AA', 'color': const Color(0xFF8E24AA)},
    {'name': 'برتقالي', 'hex': 'FFFB8C00', 'color': const Color(0xFFFB8C00)},
  ];

  String? _selectedHex;

  @override
  void initState() {
    super.initState();
    _selectedHex = widget.currentColorHex;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: CustomText(
        'اختار لون العلامة',
        textAlign: TextAlign.center,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _colors.map((c) {
              final isSelected = _selectedHex == c['hex'];
              return GestureDetector(
                onTap: () => setState(() => _selectedHex = c['hex']),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.h,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: c['color'],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: c['color'].withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? Icon(Icons.check, color: Colors.white, size: 24.sp)
                          : null,
                    ),
                    CustomText(c['name'], fontSize: 11.sp),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'remove'), // remove bookMark
          child: CustomText('مسح العلامة', color: Colors.red, fontSize: 11.sp),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel
          child: CustomText(
            'إلغاء',
            fontSize: 11.sp,
            color: Colors.teal.shade700,
          ),
        ),
        ElevatedButton(
          onPressed: _selectedHex == null
              ? null
              : () => Navigator.pop(context, _selectedHex),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: CustomText('حفظ', fontSize: 11.sp, color: Colors.white),
        ),
      ],
    );
  }
}
