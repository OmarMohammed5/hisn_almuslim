import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint;
final TextEditingController? controller;
  const SearchField({
    super.key,
    required this.onChanged,
    required this.hint,
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Listen to text changes.
    // This allows us to show/hide the clear button.
    controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Current text inside the search field.
    final query = controller.text;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1C2227)
              : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1C2227)
                    : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: isDark ? Colors.white : Colors.grey,
                size: 20.sp,
              ),
            ),

            Gap(12.w),

            Expanded(
              child: TextField(
                controller: controller,

                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },

                // Send the search text to the parent screen.
                onChanged: widget.onChanged,

                textAlign: TextAlign.right,

                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 14.sp,
                  fontFamily: "QuranFont",
                ),

                cursorColor: Colors.teal.shade700,

                decoration: InputDecoration(
                  hintText: widget.hint,

                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white54
                        : Colors.grey,
                    fontSize: 12.sp,
                  ),

                  // Show clear button only when there is text.
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      // Clear TextField.
                      controller.clear();

                      // Notify parent screen.
                      widget.onChanged('');
                    },
                    icon: const Icon(Icons.clear),
                  )
                      : null,

                  border: InputBorder.none,

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal.shade800,
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.r),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF2B2B2B)
                          : const Color(0xFFE9EEF0),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}