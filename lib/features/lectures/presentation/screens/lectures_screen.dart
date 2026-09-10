import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/helpers/lecture_progress_storage.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/lecture.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/sheikh.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_cubit.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_state.dart';
import 'package:hisn_almuslim/features/lectures/presentation/screens/lectures_screen_skeleton.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/continue_listening_card.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/dashboard_error_view.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/featured_lecture_card.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_category_chip.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/sheikh_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturesScreen extends StatefulWidget {
  final SharedPreferences preferences;

  const LecturesScreen({
    super.key,
    required this.preferences,
  });

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  static const _categories = <(String, IconData)>[
    ('القرآن والتفسير', FlutterIslamicIcons.solidQuran2),
    ('الحديث والسنة', FlutterIslamicIcons.mohammad),
    ('الفقه', Icons.balance_rounded),
    ('العقيدة', FlutterIslamicIcons.tawhid),
    ('السيرة النبوية', FlutterIslamicIcons.mohammad),
    ('قصص الأنبياء', FlutterIslamicIcons.community),
    ('الأخلاق والآداب', FlutterIslamicIcons.tawhid),
    ('الأذكار والدعاء', FlutterIslamicIcons.solidPrayer),
    ('رمضان', FlutterIslamicIcons.ramadan),
  ];

  Lecture? _continueLecture;
  LectureProgressData? _continueProgress;

  @override
  void initState() {
    super.initState();
    _refreshContinueListening();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LecturesCubit>().loadDashboard();
      }
    });
  }

  void _refreshContinueListening() {
    final lecture = LectureProgressStorage.getLastLecture(widget.preferences);
    final progress = lecture == null
        ? null
        : LectureProgressStorage.getProgress(widget.preferences, lecture.id);

    if (!mounted) return;

    setState(() {
      final shouldShow = progress != null &&
          !progress.completed &&
          progress.position > 10;
      _continueLecture = shouldShow ? lecture : null;
      _continueProgress = shouldShow ? progress : null;
    });
  }

  Future<void> _openLecture(Lecture lecture) async {
    final raw = widget.preferences.getString(
      LectureProgressStorage.progressKey(lecture.id),
    );

    double? position;
    if (raw != null && raw.isNotEmpty) {
      final parts = raw.split('|');
      if (parts.length >= 3 && parts[2] != 'true') {
        final value = double.tryParse(parts[0]);
        if (value != null && value > 10) position = value;
      }
    }

    await Navigator.pushNamed(
      context,
      AppRoutes.lecturePlayer,
      arguments: {
        'lecture': lecture,
        'preferences': widget.preferences,
        'initialPositionSeconds': position,
      },
    );

    if (mounted) _refreshContinueListening();
  }

  Future<void> _openContinueLecture() async {
    final lecture = _continueLecture;
    final progress = _continueProgress;
    if (lecture == null || progress == null) return;

    await Navigator.pushNamed(
      context,
      AppRoutes.lecturePlayer,
      arguments: {
        'lecture': lecture,
        'preferences': widget.preferences,
        'initialPositionSeconds': progress.position,
      },
    );

    if (mounted) _refreshContinueListening();
  }

  void _openSheikh(Sheikh sheikh) {
    Navigator.pushNamed(
      context,
      AppRoutes.sheikhView,
      arguments: {
        'preferences': widget.preferences,
        'sheikh': sheikh,
      },
    );
  }

  void _openCategory(String category) {
    Navigator.pushNamed(
      context,
      AppRoutes.lectureCategory,
      arguments: {
        'preferences': widget.preferences,
        'category': category,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'المحاضرات والدروس'),
      body: BlocBuilder<LecturesCubit, LecturesState>(
        builder: (context, state) {
          if (state.status == LecturesStatus.loading &&
              state.latest.isEmpty &&
              state.sheikhs.isEmpty) {
            return const LecturesScreenSkeleton();
          }

          if (state.status == LecturesStatus.failure &&
              state.latest.isEmpty &&
              state.sheikhs.isEmpty) {
            return DashboardErrorView(
              message: state.errorMessage ?? 'تعذر تحميل المحاضرات حاليًا',
              onRetry: () => context.read<LecturesCubit>().loadDashboard(),
            );
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 110.h),
            children: [
                if (_continueLecture != null && _continueProgress != null) ...[
                  ContinueListeningCard(
                    lecture: _continueLecture!,
                    progress: _continueProgress!,
                    onContinue: _openContinueLecture,
                  ),
                  Gap(24.h),
                ],

                if (state.latest.isNotEmpty) ...[
                  _buildSectionHeader(
                    title: 'مختارات اليوم',
                    subtitle: 'أحدث المحاضرات من القنوات المختارة',
                  ),
                  Gap(12.h),
                  SizedBox(
                    height: 228.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.latest.length.clamp(0, 8).toInt(),
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (_, index) {
                        final lecture = state.latest[index];
                        return FeaturedLectureCard(
                          lecture: lecture,
                          onTap: () => _openLecture(lecture),
                        );
                      },
                    ),
                  ),
                  Gap(28.h),
                ],

                _buildSectionHeader(
                  title: 'استكشف حسب الموضوع',
                  subtitle: 'اختار المجال اللي حابب تتعلم فيه',
                ),
                Gap(14.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: .98,
                  ),
                  itemBuilder: (_, index) {
                    final (label, icon) = _categories[index];
                    return LectureCategoryChip(
                      label: label,
                      icon: icon,
                      onTap: () => _openCategory(label),
                    );
                  },
                ),

                if (state.sheikhs.isNotEmpty) ...[
                  Gap(30.h),
                  _buildSectionHeader(
                    title: 'قنوات مختارة',
                    subtitle: 'مصادر محاضرات ودروس من YouTube',
                    trailing: '${state.sheikhs.length} قناة',
                  ),
                  Gap(14.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.sheikhs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: .76,
                    ),
                    itemBuilder: (_, index) {
                      final sheikh = state.sheikhs[index];
                      return SheikhCard(
                        sheikh: sheikh,
                        onTap: () => _openSheikh(sheikh),
                      );
                    },
                  ),
                ],

                if (state.status == LecturesStatus.loading) ...[
                  Gap(18.h),
                  Center(
                    child: SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: CupertinoActivityIndicator(
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ),
                ],
              ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: 3.h),
              CustomText(
                subtitle,
                maxLines: 1,
                fontSize: 10.sp,
                color: scheme.onSurface.withValues(alpha: .48),
              ),
            ],
          ),
        ),
        if (trailing != null)
          CustomText(
            trailing,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.kPrimary,
          ),
      ],
    );
  }
}
