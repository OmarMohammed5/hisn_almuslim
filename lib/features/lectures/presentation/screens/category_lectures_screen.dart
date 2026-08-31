import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_cubit.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_state.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_card.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_state_views.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/shared/search_field.dart';
import '../../domain/entities/lecture.dart';
import 'lecture_player_screen.dart';

class CategoryLecturesScreen
    extends StatefulWidget {
  final SharedPreferences preferences;
  final String category;

  const CategoryLecturesScreen({
    super.key,
    required this.preferences,
    required this.category,
  });

  @override
  State<CategoryLecturesScreen>
  createState() =>
      _CategoryLecturesScreenState();
}

class _CategoryLecturesScreenState
    extends State<CategoryLecturesScreen> {

  // Search Controller
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LecturesCubit>().searchCategory(widget.category,);

    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Open Lecture
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarWidget(title: widget.category,),

      body: BlocBuilder<LecturesCubit, LecturesState>(
        builder: (context, state) {
          return Column(
            children: [
              // Search
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w , vertical: 16.h),
                child: SearchField(
                  controller: _controller,
                  hint: 'ابحث داخل ${widget.category}...',
                  onChanged: (query) {
                    context
                        .read<LecturesCubit>()
                        .searchInCategory(
                      category:
                      widget.category,
                      query: query,
                    );
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: _getItemCount(state),
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 100.h,),
                  itemBuilder: (context , index){
                 return _buildItem( context, state, index);
                  },

                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Build Results
  Widget _buildItem(
      BuildContext context,
      LecturesState state,
      int index,
      ) {
    switch (state.status) {
      case LecturesStatus.loading:
        return const LectureCardSkeleton();

      case LecturesStatus.success:
        final lecture =
        state.searchResults[index];

        return LectureCard(
          lecture: lecture,
          onTap: () {
            _openLecture(lecture);
          },
        );

      case LecturesStatus.invalidQuery:
        return LectureFeedbackView.invalidQuery(
          message:
          state.errorMessage ??
              'يمكنك البحث فقط عن المحتوى الإسلامي.',
        );

      case LecturesStatus.failure:
        return LectureFeedbackView(
          icon: Icons.wifi_off_rounded,
          message:
          state.errorMessage ??
              'تعذر تحميل المحاضرات.',
          actionLabel: 'إعادة المحاولة',
          onAction: () {
            context
                .read<LecturesCubit>()
                .searchCategory(
              widget.category,
            );
          },
        );

      case LecturesStatus.empty:
        return const LectureFeedbackView.empty();

      case LecturesStatus.initial:
        return const LectureFeedbackView(
          icon: Icons.auto_stories_rounded,
          message: 'جاري تحميل المحاضرات...',
        );
    }
  }

  int _getItemCount(LecturesState state) {
    switch (state.status) {
      case LecturesStatus.success:
        return state.searchResults.length;

      case LecturesStatus.loading:
        return 6;

      default:
        return 1;
    }
  }

}