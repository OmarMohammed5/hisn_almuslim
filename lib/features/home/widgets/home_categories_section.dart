import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hisn_almuslim/features/home/data/models/category_model.dart';
import 'package:hisn_almuslim/features/home/widgets/category_card.dart';
import 'package:hisn_almuslim/features/home/widgets/home_section_header.dart';

class CategoriesHomeSection extends StatefulWidget {
  const CategoriesHomeSection({
    super.key,
    required this.categories,
    this.initialVisibleCount = 6,
  });

  final List<CategoryModel> categories;
  final int initialVisibleCount;

  @override
  State<CategoriesHomeSection>
  createState() => _CategoriesHomeSectionState();
}


class _CategoriesHomeSectionState extends State<CategoriesHomeSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canExpand =>
      widget.categories.length > widget.initialVisibleCount;

  int get _visibleCount {
    if (!_canExpand || _expanded) {
      return widget.categories.length;
    }
    return widget.initialVisibleCount;
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          HomeSectionHeader(
            title: 'الأقسام',
            icon: Icons.apps_rounded,
            actionLabel: _canExpand
                ? (_expanded ? 'عرض أقل' : 'عرض الكل')
                : null,
            actionIcon: _canExpand
                ? (_expanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.arrow_back_ios_new_rounded)
                : null,
            onAction: _canExpand ? _toggleExpanded : null,
          ),

          SizedBox(height: 14.h),

          // Categories with AnimatedSize + Fade/Slide for extra items
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: GridView.builder(
                key: const PageStorageKey('home_categories_grid'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _visibleCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (context, index) {
                  final category = widget.categories[index];
                  final isExtraItem = index >= widget.initialVisibleCount;

                  Widget card = CategoryCardWidget(
                    key: ValueKey(category.route),
                    title: category.title,
                    icon: category.icon,
                    onTap: () {
                      Navigator.pushNamed(context, category.route);
                    },
                  );

                  // Apply entrance animation only to the newly revealed items
                  if (isExtraItem) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
                          ),
                        ),
                        child: card,
                      ),
                    );
                  }

                  return card;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}