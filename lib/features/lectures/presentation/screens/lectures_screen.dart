import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hisn_almuslim/core/helpers/lecture_progress_storage.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/sheikh.dart';
import 'package:hisn_almuslim/features/lectures/presentation/screens/lectures_screen_skeleton.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/continue_listening_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/routing/app_routes.dart';
import '../../domain/entities/lecture.dart';
import '../cubit/lectures_cubit.dart';
import '../cubit/lectures_state.dart';
import '../widgets/lecture_category_chip.dart';
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

class _LecturesScreenState extends State<LecturesScreen> with WidgetsBindingObserver {

  late final TextEditingController _searchController;

  // ============================================================
  // Categories
  // ============================================================

  static const _categories =
  <(String, IconData)>[
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

  // Continue Listening
  Lecture? _continueLecture;

  LectureProgressData? _continueProgress;

  // Refresh Continue Listening
  void _refreshContinueListening() {
    if (!mounted) {
      return;
    }

    final lecture =
    LectureProgressStorage.getLastLecture(
      widget.preferences,
    );

    // No saved lecture
    if (lecture == null) {
      setState(() {
        _continueLecture = null;
        _continueProgress = null;
      });

      return;
    }

    // Get saved progress
    final progress =
    LectureProgressStorage.getProgress(
      widget.preferences,
      lecture.id,
    );

    // Invalid / completed progress
    if (progress == null ||
        progress.completed ||
        progress.position <= 10) {
      setState(() {
        _continueLecture = null;
        _continueProgress = null;
      });

      return;
    }

    // Valid continue listening data
    setState(() {
      _continueLecture = lecture;
      _continueProgress = progress;
    });
  }

  // Open Continue Lecture
  Future<void> _openContinueLecture() async {
    final lecture = _continueLecture;

    final progress = _continueProgress;

    if (lecture == null ||
        progress == null) {
      return;
    }

    await Navigator.pushNamed(
      context,
      AppRoutes.lecturePlayer,
      arguments: {
        'lecture': lecture,
        'preferences': widget.preferences,
        'initialPositionSeconds':
        progress.position,
      },
    );

    // IMPORTANT:
    // Refresh dashboard after returning
    // from LecturePlayerScreen.
    if (!mounted) {
      return;
    }

    _refreshContinueListening();
  }

  // Open Any Lecture
  Future<void> _openLecture(
      Lecture lecture) async {

    double? position;

    final raw =
    widget.preferences.getString(
      LectureProgressStorage.progressKey(
        lecture.id,
      ),
    );

    if (raw != null && raw.isNotEmpty) {
      final parts = raw.split('|');

      if (parts.length >= 3 &&
          parts[2] != 'true') {

        final savedPosition =
        double.tryParse(parts[0]);

        if (savedPosition != null &&
            savedPosition > 10) {
          position = savedPosition;
        }
      }
    }

    await Navigator.pushNamed(
      context,
      AppRoutes.lecturePlayer,
      arguments: {
        'lecture': lecture,
        'preferences': widget.preferences,
        'initialPositionSeconds':
        position,
      },
    );

    if (!mounted) {
      return;
    }

    _refreshContinueListening();
  }

  // App Lifecycle
  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state) {

    // When application becomes active again,
    // reload the saved lecture/progress.
    if (state ==
        AppLifecycleState.resumed) {

      _refreshContinueListening();
    }
  }

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Listen to app lifecycle changes.
    WidgetsBinding.instance
        .addObserver(this);

    _searchController =
        TextEditingController();

    // Load saved continue listening
    // immediately.
    _refreshContinueListening();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!mounted) {
        return;
      }

      context
          .read<LecturesCubit>()
          .loadDashboard();
    });
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {

    WidgetsBinding.instance
        .removeObserver(this);

    _searchController.dispose();

    super.dispose();
  }

  // ============================================================
  // Open Sheikh
  // ============================================================

  void _openSheikh(
      BuildContext context,
      Sheikh sheikh,
      ) {

    Navigator.pushNamed(
      context,
      AppRoutes.sheikhView,
      arguments: {
        'preferences':
        widget.preferences,
        'sheikh': sheikh,
      },
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {

    final scheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarWidget(
        title: 'المحاضرات و الدروس',
      ),

      body: BlocBuilder<
          LecturesCubit,
          LecturesState>(
        builder: (context, state) {

          final showingSearch =
              state.searchQuery.isNotEmpty;

          // ======================================================
          // Initial Loading
          // ======================================================

          if (state.status ==
              LecturesStatus.loading &&
              state.sheikhs.isEmpty &&
              !showingSearch) {

            return const
            LecturesScreenSkeleton();
          }

          // Dashboard Error
          if (state.status ==
              LecturesStatus.failure &&
              state.sheikhs.isEmpty &&
              !showingSearch) {

            return _DashboardErrorView(
              message:
              state.errorMessage ??
                  'حدث خطأ',

              onRetry: () {

                context
                    .read<LecturesCubit>()
                    .loadDashboard();
              },
            );
          }

          // Main Content
          return RefreshIndicator(
            color: AppColors.kPrimary,
            onRefresh: ()async =>
                _refreshContinueListening(),
            child: ListView(
              physics:
              const BouncingScrollPhysics(),

              padding:
              EdgeInsets.fromLTRB(
                16.w,
                12.h,
                16.w,
                100.h,
              ),

              children: [

                // Continue Listening Dashboard
                if (_continueLecture != null &&
                    _continueProgress != null) ...[

                  ContinueListeningCard(
                    lecture:
                    _continueLecture!,

                    progress:
                    _continueProgress!,

                    onContinue:
                    _openContinueLecture,
                  ),

                  Gap(26.h),
                ],

                // Categories
                CustomText(
                  'التصنيفات',
                  fontSize: 15.sp,
                  fontWeight:
                  FontWeight.w800,
                ),

                Gap(16.h),

                GridView.builder(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  _categories.length,

                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,

                    crossAxisSpacing:
                    10.w,

                    mainAxisSpacing:
                    10.h,

                    childAspectRatio:
                    1.05,
                  ),

                  itemBuilder:
                      (_, index) {

                    final (
                    label,
                    icon,
                    ) = _categories[index];

                    return LectureCategoryChip(
                      label: label,
                      icon: icon,

                      onTap: () {

                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .lectureCategory,

                          arguments: {
                            'preferences':
                            widget.preferences,

                            'category':
                            label,
                          },
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 26.h),

                // Featured Religious Channels
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

                        color: scheme
                            .onSurface
                            .withValues(
                          alpha: .48,
                        ),
                      ),
                    ],
                  ),

                  Gap(20.h),

                  // Sheikh Grid
                  GridView.builder(
                    shrinkWrap: true,

                    physics:
                    const NeverScrollableScrollPhysics(),

                    itemCount:
                    state.sheikhs.length,

                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,

                      crossAxisSpacing:
                      10.w,

                      mainAxisSpacing:
                      12.h,

                      childAspectRatio:
                      0.78,
                    ),

                    itemBuilder:
                        (_, index) {

                      final sheikh =
                      state.sheikhs[index];

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
            ),
          );
        },
      ),
    );
  }
}

// Dashboard Error
class _DashboardErrorView
    extends StatelessWidget {

  final String message;

  final VoidCallback onRetry;

  const _DashboardErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(
      BuildContext context) {

    return Center(
      child: Padding(
        padding:
        EdgeInsets.all(24.w),

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

              label:
              const CustomText(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}