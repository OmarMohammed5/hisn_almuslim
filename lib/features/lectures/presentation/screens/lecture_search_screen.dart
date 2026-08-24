import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/custom_text.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_cubit.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_state.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_card.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_state_views.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/lecture.dart';
import 'lecture_player_screen.dart';

class LectureSearchScreen
    extends StatefulWidget {
  final SharedPreferences preferences;

  const LectureSearchScreen({
    super.key,
    required this.preferences,
  });

  @override
  State<LectureSearchScreen> createState() =>
      _LectureSearchScreenState();
}

class _LectureSearchScreenState
    extends State<LectureSearchScreen> {
  late final TextEditingController
  _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openLecture(
      Lecture lecture,
      ) {
    final raw =
    widget.preferences.getString(
      'lecture_progress_${lecture.id}',
    );

    double? position;

    if (raw != null) {
      final parts = raw.split('|');

      if (parts.length >= 3 &&
          parts[2] != 'true') {
        position =
            double.tryParse(parts[0]);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LecturePlayerScreen(
              lecture: lecture,
              preferences:
              widget.preferences,
              initialPositionSeconds:
              position,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context)
            .colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'البحث عن المحاضرات',
          fontWeight:
          FontWeight.w800,
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<
          LecturesCubit,
          LecturesState>(
        builder: (context, state) {
          return ListView(
            padding:
            EdgeInsets.fromLTRB(
              16.w,
              12.h,
              16.w,
              100.h,
            ),
            children: [
              SearchField(
                controller:
                _controller,

                hint:
                'ابحث عن محاضرة أو موضوع...',

                onChanged: context
                    .read<LecturesCubit>()
                    .search,

                onSubmitted: context
                    .read<LecturesCubit>()
                    .search,
              ),

              SizedBox(height: 20.h),

              if (state.searchQuery
                  .isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        'نتائج البحث',
                        fontSize: 16.sp,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),

                    if (state.status ==
                        LecturesStatus
                            .success)
                      CustomText(
                        '${state.searchResults.length} نتيجة',
                        fontSize: 10.sp,
                        color: scheme
                            .onSurface
                            .withValues(
                          alpha: .5,
                        ),
                      ),
                  ],
                ),

              SizedBox(height: 10.h),

              _buildResults(
                context,
                state,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResults(
      BuildContext context,
      LecturesState state,
      ) {
    switch (state.status) {
      case LecturesStatus.loading:
        return const LectureResultsSkeleton();

      case LecturesStatus.invalidQuery:
        return LectureFeedbackView.invalidQuery(
          message:
          state.errorMessage ??
              'يمكنك البحث فقط عن المحتوى الإسلامي.',
        );

      case LecturesStatus.failure:
        return LectureFeedbackView(
          icon:
          Icons.wifi_off_rounded,
          message:
          state.errorMessage ??
              'تعذر تنفيذ البحث الآن.',
          actionLabel:
          'إعادة المحاولة',
          onAction: () {
            context
                .read<LecturesCubit>()
                .retrySearch();
          },
        );

      case LecturesStatus.empty:
        return const LectureFeedbackView.empty();

      case LecturesStatus.success:
        if (state.searchResults
            .isEmpty) {
          return const LectureFeedbackView
              .empty();
        }

        return Column(
          children: state.searchResults
              .map(
                (lecture) =>
                LectureCard(
                  lecture: lecture,
                  onTap: () =>
                      _openLecture(
                        lecture,
                      ),
                ),
          )
              .toList(),
        );

      case LecturesStatus.initial:
        return Padding(
          padding:
          EdgeInsets.symmetric(
            vertical: 60.h,
          ),
          child: const LectureFeedbackView(
            icon:
            Icons.search_rounded,
            message:
            'اكتب ما تريد البحث عنه من المحاضرات والمحتوى الإسلامي.',
          ),
        );
    }
  }
}