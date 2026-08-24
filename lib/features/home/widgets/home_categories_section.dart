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

class _CategoriesHomeSectionState
    extends State<CategoriesHomeSection> {
  bool _expanded = false;

  bool get _canExpand =>
      widget.categories.length >
          widget.initialVisibleCount;

  int get _visibleCount {
    if (!_canExpand || _expanded) {
      return widget.categories.length;
    }

    return widget.initialVisibleCount;
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [

          // Section Header
          HomeSectionHeader(
            title: 'الأقسام',
            icon: Icons.apps_rounded,
            actionLabel: _canExpand
                ? (_expanded
                ? 'عرض أقل'
                : 'عرض الكل')
                : null,
            actionIcon: _canExpand
                ? (_expanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.arrow_back_ios_new_rounded)
                : null,
            onAction: _canExpand
                ? _toggleExpanded
                : null,
          ),

          SizedBox(height: 14.h),


          // Categories
          ClipRect(
            child: AnimatedSize(
              duration:
              const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: GridView.builder(
                key: const PageStorageKey(
                  'home_categories_grid',
                ),
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: _visibleCount,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.38,
                ),
                itemBuilder: (context, index) {
                  final category =
                  widget.categories[index];

                  return CategoryCardWidget(
                    key: ValueKey(
                      category.route,
                    ),
                    title: category.title,
                    icon: category.icon,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        category.route,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}