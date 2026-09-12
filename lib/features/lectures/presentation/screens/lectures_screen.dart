import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_content_container.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
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

  const LecturesScreen({super.key, required this.preferences});

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
      final shouldShow =
          progress != null && !progress.completed && progress.position > 10;
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
      arguments: {'preferences': widget.preferences, 'sheikh': sheikh},
    );
  }

  void _openCategory(String category) {
    Navigator.pushNamed(
      context,
      AppRoutes.lectureCategory,
      arguments: {'preferences': widget.preferences, 'category': category},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);
    final isTablet = AppResponsive.isTablet(context);

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

          return LectureContentContainer(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: AppResponsive.heightValue(context, 12),
                bottom: AppResponsive.heightValue(context, 32),
              ),
              children: [
                if (_continueLecture != null && _continueProgress != null) ...[
                  ContinueListeningCard(
                    lecture: _continueLecture!,
                    progress: _continueProgress!,
                    onContinue: _openContinueLecture,
                  ),
                  Gap(AppResponsive.heightValue(context, isMobile ? 24 : 20)),
                ],

                if (state.latest.isNotEmpty) ...[
                  _buildSectionHeader(
                    title: 'مختارات اليوم',
                    subtitle: 'أحدث المحاضرات من القنوات المختارة',
                  ),
                  Gap(AppResponsive.heightValue(context, 12)),

                  if (isMobile)
                    SizedBox(
                      height: AppResponsive.heightValue(context, 310),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.latest.length.clamp(0, 8).toInt(),
                        separatorBuilder: (_, __) => SizedBox(
                          width: AppResponsive.widthValue(context, 12),
                        ),
                        itemBuilder: (_, index) {
                          final lecture = state.latest[index];
                          return FeaturedLectureCard(
                            lecture: lecture,
                            onTap: () => _openLecture(lecture),
                          );
                        },
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.latest.length
                          .clamp(0, isTablet ? 4 : 6)
                          .toInt(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 2 : 3,
                        crossAxisSpacing: AppResponsive.widthValue(context, 14),
                        mainAxisSpacing: AppResponsive.heightValue(context, 14),
                        // 👇 FIX 1 (cont): Increased height from 252 to 310
                        mainAxisExtent: AppResponsive.heightValue(context, 310),
                      ),
                      itemBuilder: (_, index) {
                        final lecture = state.latest[index];
                        return FeaturedLectureCard(
                          lecture: lecture,
                          onTap: () => _openLecture(lecture),
                          width: double.infinity,
                        );
                      },
                    ),

                  Gap(AppResponsive.heightValue(context, isMobile ? 28 : 24)),
                ],

                _buildSectionHeader(
                  title: 'استكشف حسب الموضوع',
                  subtitle: 'اختار المجال اللي حابب تتعلم فيه',
                ),
                Gap(AppResponsive.heightValue(context, 14)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 3 : (isTablet ? 4 : 5),
                    crossAxisSpacing: AppResponsive.widthValue(context, 10),
                    mainAxisSpacing: AppResponsive.heightValue(context, 10),
                    mainAxisExtent: AppResponsive.heightValue(
                      context,
                      isMobile ? 126 : (isTablet ? 132 : 138),
                    ),
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
                  Gap(AppResponsive.heightValue(context, isMobile ? 30 : 24)),
                  _buildSectionHeader(
                    title: 'قنوات مختارة',
                    subtitle: 'مصادر محاضرات ودروس من YouTube',
                    trailing: '${state.sheikhs.length} قناة',
                  ),
                  Gap(AppResponsive.heightValue(context, 14)),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.sheikhs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 3 : (isTablet ? 4 : 6),
                      crossAxisSpacing: AppResponsive.widthValue(context, 10),
                      mainAxisSpacing: AppResponsive.heightValue(context, 10),
                      mainAxisExtent: AppResponsive.heightValue(
                        context,
                        isMobile ? 150 : (isTablet ? 158 : 166),
                      ),
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
                  Gap(AppResponsive.heightValue(context, 18)),
                  Center(
                    child: SizedBox(
                      width: AppResponsive.widthValue(context, 22),
                      height: AppResponsive.widthValue(context, 22),
                      child: CupertinoActivityIndicator(
                        color: AppColors.kPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
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
                fontSize: AppResponsive.fontSize(context, 13),
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: AppResponsive.heightValue(context, 8)),
              CustomText(
                subtitle,
                maxLines: 1,
                fontSize: AppResponsive.fontSize(context, 9.4),
                color: scheme.onSurface.withValues(alpha: .48),
              ),
            ],
          ),
        ),
        if (trailing != null)
          CustomText(
            trailing,
            fontSize: AppResponsive.fontSize(context, 10.5),
            fontWeight: FontWeight.w700,
            color: AppColors.kPrimary,
          ),
      ],
    );
  }
}