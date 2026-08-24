import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/sheikh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routing/app_routes.dart';
import '../cubit/lectures_cubit.dart';
import '../cubit/lectures_state.dart';
import '../widgets/lecture_category_chip.dart';
import '../widgets/lecture_state_views.dart';
import '../widgets/sheikh_card.dart';

class LecturesScreen extends StatefulWidget {
  final SharedPreferences preferences;

  const LecturesScreen({
    super.key,
    required this.preferences,
  });

  @override
  State<LecturesScreen> createState() =>
      _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  late final TextEditingController _searchController;

  // Categories
  static const _categories = <(String, IconData)>[
    (
    'القرآن والتفسير',
    FlutterIslamicIcons.solidQuran2,
    ),
    (
    'الحديث والسنة',
    FlutterIslamicIcons.mohammad,
    ),
    (
    'الفقه',
    Icons.balance_rounded,
    ),
    (
    'العقيدة',
    FlutterIslamicIcons.tawhid,
    ),
    (
    'السيرة النبوية',
    FlutterIslamicIcons.mohammad,
    ),
    (
    'قصص الأنبياء',
    FlutterIslamicIcons.community,
    ),
    (
    'الأخلاق والآداب',
    FlutterIslamicIcons.tawhid,
    ),
    (
    'الأذكار والدعاء',
    FlutterIslamicIcons.solidPrayer,
    ),
    (
    'رمضان',
    FlutterIslamicIcons.ramadan,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LecturesCubit>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  // Open Sheikh
  void _openSheikh(
      BuildContext context,
      Sheikh sheikh,
      ) {
    Navigator.pushNamed(
      context,
      AppRoutes.sheikhView,
      arguments: {
        'preferences': widget.preferences,
        'sheikh': sheikh,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarWidget(title: 'المحاضرات و الدروس',),
      body: BlocBuilder<LecturesCubit, LecturesState>(
        builder: (context, state) {
          final showingSearch = state.searchQuery.isNotEmpty;

          // Initial Loading
          if (state.status == LecturesStatus.loading && state.sheikhs.isEmpty && !showingSearch) {
            return Center(child: CupertinoActivityIndicator(color: AppColors.kPrimary,),);
            //   ListView(
            //   padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h,),
            //   children: const [
            //     LectureResultsSkeleton(count: 5,),
            //   ],
            // );
          }

          // Dashboard Error
          if (state.status ==
              LecturesStatus.failure &&
              state.sheikhs.isEmpty &&
              !showingSearch) {
            return _DashboardErrorView(
              message: state.errorMessage ??
                  'حدث خطأ',
              onRetry: () {
                context
                    .read<LecturesCubit>()
                    .loadDashboard();
              },
            );
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h,),
            children: [
              /// Dashboard

                Gap(20.h),
                // Categories
                CustomText(
                  'التصنيفات',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),

                Gap(16.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1.05,
                  ),

                  itemBuilder: (_, index) {
                    final (label, icon, ) = _categories[index];

                    return LectureCategoryChip(
                      label: label,
                      icon: icon,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.lectureCategory,
                          arguments: {
                            'preferences':
                            widget.preferences,
                            'category': label,
                          },
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 26.h),

                // Featured Sheikhs
                if (state.sheikhs.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          'قنوات دينية',
                          fontSize: 17.sp,
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),

                      CustomText(
                        '${state.sheikhs.length} قناة',
                        fontSize: 12.sp,
                        color: scheme.onSurface.withValues(alpha: .48,),
                      ),
                    ],
                  ),

                  Gap(20.h),

                  // Sheikh Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.sheikhs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (_, index) {
                      final sheikh = state.sheikhs[index];
                      return SheikhCard(
                        sheikh: sheikh,
                        onTap: () {
                          _openSheikh(
                            context,
                            sheikh,
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 24.h),
                ],
              ],
          );
        },
      ),
    );
  }
}

// Dashboard Error
class _DashboardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 42.sp,
            ),

            SizedBox(height: 12.h),

            CustomText(
              message,
              textAlign:
              TextAlign.center,
            ),

            SizedBox(height: 14.h),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const CustomText(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
