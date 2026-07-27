import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/shared/custom_text.dart';
import 'package:hisn_almuslim/theme/app_colors.dart';

class GlassBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItemData> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<GlassBottomNavBar> createState() => _GlassBottomNavBarState();
}

class BottomNavItemData {
  final Widget icon;
  final String label;
  final Widget filledIcon;
  BottomNavItemData({
    required this.icon,
    required this.label,
    required this.filledIcon,
  });
}

class _GlassBottomNavBarState extends State<GlassBottomNavBar> {
  double _pillLeft = 0;
  @override
  void didUpdateWidget(covariant GlassBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePill());
  }

  void _updatePill() {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width;
    final itemWidth = width / widget.items.length;
    final targetLeft = itemWidth * widget.currentIndex + (itemWidth - 100) / 2;
    setState(() => _pillLeft = targetLeft.clamp(3.0, width + 64.0));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Material(
        elevation: 10,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(100),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final itemWidth = totalWidth / widget.items.length;
            final initialLeft =
                itemWidth * widget.currentIndex + (itemWidth - 40) / 2;
            if (_pillLeft == 0) _pillLeft = initialLeft;

            return ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 80),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        blurRadius: 25,
                        offset: Offset(10, 40),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 250),
                        curve: Curves.linear,
                        left: _pillLeft,
                        top: -4,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 70, sigmaY: 60),
                            child: SizedBox(),
                          ),
                        ),
                      ),

                      ///Row with items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(widget.items.length, (index) {
                          final item = widget.items[index];
                          final isSelected = index == widget.currentIndex;
                          return Expanded(
                            child: InkWell(
                              onTap: () {
                                widget.onTap(index);
                                final targetLeft =
                                    itemWidth * index + (itemWidth - 10) / 2;
                                setState(
                                  () => _pillLeft = targetLeft.clamp(
                                    10.0,
                                    totalWidth - 100.0,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 72,
                                decoration: isSelected
                                    ? BoxDecoration(
                                        color: isDark
                                            ? Color(0xff00573d)
                                            : Color(0xff009b84),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      )
                                    : null,
                                padding: isSelected
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 5,
                                      )
                                    : null,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 280),
                                      child: IconTheme(
                                        data: IconThemeData(
                                          size: isSelected ? 25 : 20,
                                          color: isSelected
                                              ? AppColors.bgColor.withValues(
                                                  alpha: 0.9,
                                                )
                                              : Colors.grey.shade600,
                                        ),
                                        child: isSelected
                                            ? item.filledIcon
                                            : item.icon,
                                      ),
                                    ),
                                    Gap(2),
                                    CustomText(
                                      item.label,
                                      fontSize: 11.7,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.bgColor.withValues(
                                              alpha: 0.6,
                                            )
                                          : Colors.grey.shade600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
