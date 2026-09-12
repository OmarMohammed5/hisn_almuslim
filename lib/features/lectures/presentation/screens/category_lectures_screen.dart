import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_content_container.dart';
import 'package:hisn_almuslim/core/responsive/app_responsive.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/shared/search_field.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import 'package:hisn_almuslim/features/lectures/domain/entities/lecture.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_cubit.dart';
import 'package:hisn_almuslim/features/lectures/presentation/cubit/lectures_state.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_card.dart';
import 'package:hisn_almuslim/features/lectures/presentation/widgets/lecture_state_views.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/routing/app_routes.dart';

class CategoryLecturesScreen extends StatefulWidget {
  final SharedPreferences preferences;
  final String category;

  const CategoryLecturesScreen({
    super.key,
    required this.preferences,
    required this.category,
  });

  @override
  State<CategoryLecturesScreen> createState() => _CategoryLecturesScreenState();
}

class _CategoryLecturesScreenState extends State<CategoryLecturesScreen> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LecturesCubit>().searchCategory(widget.category);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    const threshold = 500.0;

    if (position.maxScrollExtent - position.pixels <= threshold) {
      context.read<LecturesCubit>().loadMoreCategory();
    }
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<LecturesCubit>().searchInCategory(
      category: widget.category,
      query: _controller.text,
    );
  }

  void _clearSearch() {
    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read<LecturesCubit>().searchCategory(widget.category);
    setState(() {});
  }

  Future<void> _openLecture(Lecture lecture) async {
    final raw = widget.preferences.getString('lecture_progress_${lecture.id}');
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
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarWidget(title: widget.category),
      body: LectureContentContainer(
        child: BlocBuilder<LecturesCubit, LecturesState>(
          builder: (context, state) {
            final isInitialLoading =
                state.status == LecturesStatus.loading &&
                state.searchResults.isEmpty &&
                !state.isLoadingMoreCategory;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppResponsive.widthValue(context, 16),
                    AppResponsive.heightValue(context, 14),
                    AppResponsive.widthValue(context, 16),
                    AppResponsive.heightValue(context, 8),
                  ),
                  child: _buildSearchField(scheme, state),
                ),
                Expanded(
                  child: isInitialLoading
                      ? const SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: LectureResultsSkeleton(count: 6),
                        )
                      : _buildResults(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField(ColorScheme scheme, LecturesState state) {

    return SearchField(
      controller: _controller,
      onChanged: (value) {
        setState(() {});
        context.read<LecturesCubit>().onCategorySearchChanged(
          category: widget.category,
          query: value,
        );
      },
      onSubmitted: (_) => _submitSearch(),
      hint: 'ابحث داخل ${widget.category}...',
    );
  }

  Widget _buildResults(BuildContext context, LecturesState state) {
    switch (state.status) {
      case LecturesStatus.invalidQuery:
        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 10),
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 100),
          ),
          children: [
            LectureFeedbackView.invalidQuery(
              message: state.errorMessage ?? 'اكتب بحثًا صالحًا.',
            ),
          ],
        );

      case LecturesStatus.failure:
        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 10),
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 100),
          ),
          children: [
            LectureFeedbackView(
              icon: Icons.wifi_off_rounded,
              message: state.errorMessage ?? 'تعذر تحميل المحاضرات.',
              actionLabel: 'إعادة المحاولة',
              onAction: () {
                context.read<LecturesCubit>().searchInCategory(
                  category: widget.category,
                  query: _controller.text,
                );
              },
            ),
          ],
        );

      case LecturesStatus.empty:
        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 10),
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 100),
          ),
          children: const [LectureFeedbackView.empty()],
        );

      case LecturesStatus.initial:
        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 10),
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 100),
          ),
          children: const [
            LectureFeedbackView(
              icon: Icons.auto_stories_rounded,
              message: 'جاري تحميل المحاضرات...',
            ),
          ],
        );

      case LecturesStatus.loading:
      case LecturesStatus.success:
        final showPaginationError =
            state.searchResults.isNotEmpty &&
            state.errorMessage != null &&
            !state.isLoadingMoreCategory;
        final itemCount =
            state.searchResults.length +
            (state.isLoadingMoreCategory || showPaginationError ? 1 : 0);

        if (state.searchResults.isEmpty) {
          return const LectureFeedbackView.empty();
        }

        return ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 10),
            AppResponsive.widthValue(context, 16),
            AppResponsive.heightValue(context, 100),
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= state.searchResults.length) {
              if (state.isLoadingMoreCategory) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppResponsive.heightValue(context, 18),
                  ),
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.kPrimary,
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(
                  top: AppResponsive.heightValue(context, 4),
                  bottom: AppResponsive.heightValue(context, 20),
                ),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<LecturesCubit>().loadMoreCategory(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة تحميل المزيد'),
                  ),
                ),
              );
            }

            final lecture = state.searchResults[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: AppResponsive.heightValue(context, 12),
              ),
              child: LectureCard(
                lecture: lecture,
                onTap: () => _openLecture(lecture),
              ),
            );
          },
        );
    }
  }
}
