import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/routing/app_routes.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/core/theme/app_colors.dart';
import '../../../../core/responsive/app_responsive.dart';
import '../../../../core/shared/re_build_scroll_To_Top.dart';
import '../../../../core/shared/search_field.dart';
import '../../domain/entities/prophet_story.dart';
import '../cubit/stories_cubit.dart';
import '../cubit/stories_state.dart';
import '../widgets/story_card.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  /// Scroll
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<StoriesCubit>().loadStories();

    _scrollController.addListener(() {
      _showScrollToTop.value = _scrollController.offset > 300;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _showScrollToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = AppResponsive.isDesktop(context)
        ? 1100.0
        : AppResponsive.isTablet(context)
        ? 820.0
        : double.infinity;

    return Scaffold(
      appBar: AppBarWidget(title: "قصص الأنبياء"),
      body: SafeArea(
        child: AppResponsive.constrain(
          context,
          maxWidth: maxWidth,
          child: Column(
            children: [
              // Search with padding
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: SearchField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<StoriesCubit>().searchStories(query);
                  },
                  hint: "ابحث في قصص الأنبياء",
                ),
              ),

              // Stories list
              Expanded(
                child: BlocBuilder<StoriesCubit, StoriesState>(
                  builder: (context, state) {
                    if (state is StoriesLoading) {
                      return const _LoadingView();
                    }

                    if (state is StoriesError) {
                      return _ErrorView(
                        message: state.message,
                        onRetry: () =>
                            context.read<StoriesCubit>().loadStories(),
                      );
                    }

                    if (state is StoriesLoaded) {
                      if (state.filteredStories.isEmpty) {
                        return _EmptyView(
                          searchQuery: state.searchQuery,
                          onClear: () {
                            _searchController.clear();
                            context.read<StoriesCubit>().clearSearch();
                          },
                        );
                      }

                      return _StoriesListView(
                        controller: _scrollController,
                        stories: state.filteredStories,
                        totalStories: state.stories.length,
                        searchQuery: state.searchQuery,
                        onSearchCleared: () {
                          _searchController.clear();
                          context.read<StoriesCubit>().clearSearch();
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ReBuildScrollToTop(
        showScrollToTop: _showScrollToTop,
        scrollController: _scrollController,
      ),
    );
  }
}

// ===== Loading View =====
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 28.w,
            height: 28.w,
            child: CupertinoActivityIndicator(color: AppColors.kPrimary),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.5),
              fontFamily: 'QuranFont',
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Error View =====
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppResponsive.widthValue(context, 60),
              height: AppResponsive.heightValue(context, 60),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: AppResponsive.iconSize(context, 28),
                color: Colors.red.shade300,
              ),
            ),
            SizedBox(height: AppResponsive.heightValue(context, 16)),
            Text(
              'حدث خطأ أثناء التحميل',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontFamily: 'Noon',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.heightValue(context, 6)),
            Text(
              message,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13),
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                fontFamily: 'QuranFont',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppResponsive.heightValue(context, 20)),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.widthValue(context, 24),
                  vertical: AppResponsive.heightValue(context, 10),
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 10),
                  ),
                ),
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'QuranFont',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Empty View =====
class _EmptyView extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback onClear;

  const _EmptyView({this.searchQuery, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppResponsive.widthValue(context, 32),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppResponsive.widthValue(context, 60),
              height: AppResponsive.heightValue(context, 60),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: AppResponsive.iconSize(context, 28),
                color: primaryColor.withOpacity(0.4),
              ),
            ),
            SizedBox(height: AppResponsive.heightValue(context, 16)),
            Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 16),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontFamily: 'Noon',
              ),
            ),
            if (searchQuery != null) ...[
              SizedBox(height: AppResponsive.heightValue(context, 4)),
              Text(
                '"$searchQuery"',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 13),
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.4),
                  fontFamily: 'Noon',
                ),
              ),
            ],
            SizedBox(height: AppResponsive.heightValue(context, 4)),
            Text(
              'جرّب البحث باسم نبي أو كلمة أخرى',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13),
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.4),
                fontFamily: 'Noon',
              ),
            ),
            if (searchQuery != null) ...[
              SizedBox(height: AppResponsive.heightValue(context, 16)),
              GestureDetector(
                onTap: onClear,
                child: Text(
                  'مسح البحث',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 14),
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontFamily: 'Noon',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== Stories List View =====
class _StoriesListView extends StatelessWidget {
  final ScrollController? controller;
  final List<ProphetStory> stories;
  final int totalStories;
  final String? searchQuery;
  final VoidCallback onSearchCleared;

  const _StoriesListView({
    required this.stories,
    required this.totalStories,
    this.searchQuery,
    required this.onSearchCleared,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.widthValue(context, 20),
        vertical: AppResponsive.heightValue(context, 4),
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        final isFirst = index == 0;
        final isLast = index == stories.length - 1;

        return Column(
          children: [
            // Result count (only at top)
            if (index == 0 && searchQuery != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: AppResponsive.heightValue(context, 8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),

            // Story card
            StoryCard(
              story: story,
              index: index,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.storyDetails,
                  arguments: {
                    'story': story,
                    'allStories': stories,
                    'currentIndex': index,
                  },
                );
              },
            ),

            // Bottom padding for last item
            if (isLast)
              SizedBox(height: AppResponsive.heightValue(context, 12)),
          ],
        );
      },
    );
  }
}
