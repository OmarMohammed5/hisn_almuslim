import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hisn_almuslim/core/shared/app_bar_widget.dart';
import 'package:hisn_almuslim/features/quran/widgets/search_field.dart';
import 'package:hisn_almuslim/features/stories/ui/screens/story_details_screen.dart';
import '../../domain/entities/prophet_story.dart';
import '../cubit/stories_cubit.dart';
import '../cubit/stories_state.dart';
import '../widgets/story_card.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<StoriesCubit>().loadStories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "قصص الأنبياء"),
      body: SafeArea(
        child: Column(
          children: [
        
            // Search with padding
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child:
              SearchField(
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
                      onRetry: () => context.read<StoriesCubit>().loadStories(),
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
            child: CircularProgressIndicator(
              strokeWidth: 2.5.w,
              color: Theme.of(context).primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 28.sp,
                color: Colors.red.shade300,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'حدث خطأ أثناء التحميل',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontFamily: 'QuranFont',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                fontFamily: 'QuranFont',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontSize: 14.sp,
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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 28.sp,
                color: primaryColor.withOpacity(0.4),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontFamily: 'Cairo',
              ),
            ),
            if (searchQuery != null) ...[
              SizedBox(height: 4.h),
              Text(
                '"$searchQuery"',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4),
                  fontFamily: 'Cairo',
                ),
              ),
            ],
            SizedBox(height: 4.h),
            Text(
              'جرّب البحث باسم نبي أو كلمة أخرى',
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4),
                fontFamily: 'QuranFont',
              ),
            ),
            if (searchQuery != null) ...[
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: onClear,
                child: Text(
                  'مسح البحث',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontFamily: 'QuranFont',
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
  final List<ProphetStory> stories;
  final int totalStories;
  final String? searchQuery;
  final VoidCallback onSearchCleared;

  const _StoriesListView({
    required this.stories,
    required this.totalStories,
    this.searchQuery,
    required this.onSearchCleared,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
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
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  ],
                ),
              ),

            // Story card
            StoryCard(
              story: story,
              index: index,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StoryDetailsScreen(
                      story: story,
                      allStories: stories,
                      currentIndex: index,
                    ),
                  ),
                );
              },
            ),

            // Bottom padding for last item
            if (isLast) SizedBox(height: 12.h),
          ],
        );
      },
    );
  }
}