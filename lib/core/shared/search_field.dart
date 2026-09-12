import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';

import '../responsive/app_responsive.dart';

class SearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hint;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    required this.onChanged,
    required this.hint,
    this.onSubmitted,
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;

    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);

    if (_ownsController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final query = _controller.text;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: AppResponsive.heightValue(context, 52),
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 4),
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, 28),
          ),
          border: Border.all(
            color: AppColors.kPrimary.withValues(alpha: isDark ? .16 : .08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .08 : .025),
              blurRadius: 2.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppResponsive.widthValue(context, 42),
              height: AppResponsive.heightValue(context, 42),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kPrimary.withValues(alpha: isDark ? .14 : .07),
              ),
              child: Icon(
                CupertinoIcons.search,
                color: AppColors.kPrimary,
                size: AppResponsive.iconSize(context, 20),
              ),
            ),
            Gap(AppResponsive.widthValue(context, 10)),
            Expanded(
              child: TextField(
                controller: _controller,
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                textAlign: TextAlign.right,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: AppResponsive.fontSize(context, 13),
                  fontFamily: 'Noon',
                ),
                cursorColor: AppColors.kPrimary,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    color: scheme.onSurface.withValues(alpha: .45),
                    fontSize: AppResponsive.fontSize(context, 11.5),
                  ),

                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();

                            widget.onChanged('');
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            size: AppResponsive.iconSize(context, 19),
                            color: scheme.onSurface.withValues(alpha: .45),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal.shade800,
                      width: AppResponsive.widthValue(context, 2),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppResponsive.radius(context, 25)),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF2B2B2B)
                          : const Color(0xFFE9EEF0),
                      width: AppResponsive.widthValue(context, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppResponsive.radius(context, 25)),
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
